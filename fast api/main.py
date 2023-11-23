from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
import smtplib
from typing import Union

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import urllib
import numpy as np
import mysql.connector
import cv2
import pyttsx3
import pickle
from datetime import datetime, timedelta
import sys
import PySimpleGUI as sg
import win32gui


#create app
app = FastAPI()

#allow cross origin
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

#connect to database
myconn = mysql.connector.connect(host="localhost", user="root", passwd="12345678", database="face")
date = datetime.utcnow()
now = datetime.now()
current_time = now.strftime("%H:%M:%S")
cursor = myconn.cursor()

#2 Load recognize and read label from model
recognizer = cv2.face.LBPHFaceRecognizer_create()
recognizer.read("train.yml")

labels = {"person_name": 1}
with open("labels.pickle", "rb") as f:
    labels = pickle.load(f)
    labels = {v: k for k, v in labels.items()}

# create text to speech
engine = pyttsx3.init()
rate = engine.getProperty("rate")
engine.setProperty("rate", 175)


#login api
@app.post("/login")
def login(data: dict):
    print(data['username'])
    print(data['password'])
    query = 'select * from student where username = "'+data['username']+'" and password = "'+data['password']+'"'
    cursor.execute(query)
    user = cursor.fetchone()
    if not user:
        return {"login": "failed", 'error': 'Invalid username or password'}
    # Define camera and detect face
    face_cascade = cv2.CascadeClassifier('haarcascade/haarcascade_frontalface_default.xml')
    cap = cv2.VideoCapture(0)
    cv2.namedWindow('Window', cv2.WINDOW_NORMAL)
    cv2.setWindowProperty('Window', cv2.WND_PROP_TOPMOST, 1)
    faceRecognized = False
    counter = 0
    notInDb = 0
    # 3 Open the camera and start face recognition
    while True:
        ret, frame = cap.read()
        gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
        faces = face_cascade.detectMultiScale(gray, scaleFactor=1.5, minNeighbors=5)

        for (x, y, w, h) in faces:
            print(x, w, y, h)
            roi_gray = gray[y:y + h, x:x + w]
            roi_color = frame[y:y + h, x:x + w]
            # predict the id and confidence for faces
            id_, conf = recognizer.predict(roi_gray)

            # If the face is recognized
            if conf >= 60:
                # print(id_)
                # print(labels[id_])
                font = cv2.QT_FONT_NORMAL
                id = 0
                id += 1
                name = labels[id_]
                current_name = name
                color = (255, 0, 0)
                stroke = 2
                cv2.putText(frame, name, (x, y), font, 1, color, stroke, cv2.LINE_AA)
                cv2.rectangle(frame, (x, y), (x + w, y + h), (255, 0, 0), (2))

                # Find the student's information in the database.
                select = "SELECT student_id, name, DAY(login_date), MONTH(login_date), YEAR(login_date) FROM Student WHERE name ='%s';" % (name)
                name = cursor.execute(select)
                result = cursor.fetchall()
                # print(result)
                data = "error"

                for x in result:
                    data = x

                # If the student's information is not found in the database
                if data == "error":

                    print("The student", current_name, "is NOT FOUND in the database.")
                    notInDb+=1
                    if(notInDb > 5):
                        cap.release()
                        cv2.destroyAllWindows()
                        return {"login": "failed", 'error': 'Student not found in database'}
                # If the student's information is found in the database
                else:
                    """
                    Implement useful functions here.
                    Check the course and classroom for the student.
                        If the student has class room within one hour, the corresponding course materials
                            will be presented in the GUI.
                        if the student does not have class at the moment, the GUI presents a personal class 
                            timetable for the student.

                    """
                    counter += 1
                    if(counter > 5):
                        if(user[1].upper() == current_name.upper()):
                            faceRecognized = True
                        cap.release()
                        cv2.destroyAllWindows()
                        if faceRecognized:
                            storeLogin(user[0])
                            return {"login": "success", 'student_id':user[0]}
                        else:
                            return {"login": "failed", 'error': 'Face not recognized'}
                        

                    # Update the data in database
                    update =  "UPDATE Student SET login_date=%s WHERE student_id=%s"
                    val = (date, user[0])
                    cursor.execute(update, val)
                    update = "UPDATE Student SET login_time=%s WHERE student_id=%s"
                    val = (current_time, user[0])
                    cursor.execute(update, val)
                    myconn.commit()
                
                    hello = ("Hello ", current_name, "You did attendance today")
                    # print(hello)
                    engine.say(hello)
                    # engine.runAndWait()


            # If the face is unrecognized
            else: 
                color = (255, 0, 0)
                stroke = 2
                font = cv2.QT_FONT_NORMAL
                cv2.putText(frame, "UNKNOWN", (x, y), font, 1, color, stroke, cv2.LINE_AA)
                cv2.rectangle(frame, (x, y), (x + w, y + h), (255, 0, 0), (2))
                hello = ("Your face is not recognized")
                # print(hello)
                engine.say(hello)
                # engine.runAndWait()

        cv2.imshow('Window', frame)
        k = cv2.waitKey(20) & 0xff
        if k == ord('q'):
            break
            
    cap.release()
    cv2.destroyAllWindows()

    if faceRecognized:
        return {"login": "success", 'student_id':user[0]}
    else:
        return {"login": "failed"}
def storeLogin(uid):
    query = 'insert into login (student_id, login_date, login_time) values (%s, %s, %s)'
    date = datetime.utcnow()
    now = datetime.now()
    current_time = now.strftime("%H:%M:%S")
    cursor.execute(query, (uid, date, current_time))
    myconn.commit()





@app.post("/loginHistory")
def loginHistory(data: dict):
    print(data['student_id'])
    query = 'select * from login where student_id = '+str(data['student_id']) + " ORDER BY login_date DESC, login_time DESC"
    cursor.execute(query)
    history = cursor.fetchall()
    return history


@app.post("/schedule")
def schedule(data: dict):
    print(data['student_id'])
    query = 'select * from face.course as course natural join (select * from face.class where course_id in (select course_id from face.istaking where student_id = ' + str(data['student_id'])+ ' )) as class;'
    cursor.execute(query)

    columns = [desc[0] for desc in cursor.description]
    results = cursor.fetchall() 
    print(results)

    classes = []
    for row in results:
        mapped_row = dict(zip(columns, row))
        classes.append(mapped_row)

    print(classes)
    return classes


@app.post("/student")
def getStudent(data: dict):
    print(data['student_id'])
    query = 'select * from student where student_id = '+str(data['student_id'])
    cursor.execute(query)
    student = cursor.fetchone()
    return student

@app.post("/updateStudent")
def updateStudent(data: dict):
    print(data['student_id'])
    print(data['name'])
    print(data['username'])
    print(data['password'])
    query = 'update student set email = "' + data['email'] + '", name = "'+data['name']+'", username = "'+data['username']+'", password = "'+data['password']+'" where student_id = '+str(data['student_id'])
    print(cursor.execute(query))
    myconn.commit()
    return {"update": "success"}


@app.post("/upcomingClasses")
def upcomingClasses(data: dict):
    print(data['student_id'])
    start = datetime.now()
    weekday = start.weekday() + 1
    end = start + timedelta(hours=4)
    start = start.strftime("%H:%M:%S")
    end = end.strftime("%H:%M:%S")
    # query = query = 'select * from face.course as course natural join (select * from face.class where course_id in (select course_id from face.istaking where student_id = ' + str(data['student_id'])+ ' )) as class'
    query = query = 'select * from face.course as course natural join (select * from face.class where course_id in (select course_id from face.istaking where student_id = ' + str(data['student_id'])+ ' )) as class where class.day_of_the_week = "'+ str(weekday) +'" and class.start_time > "'+ start + '" and class.start_time < "'+ end + '"'
    cursor.execute(query)   


    columns = [desc[0] for desc in cursor.description]
    results = cursor.fetchall() 

    classes = []
    for row in results:
        mapped_row = dict(zip(columns, row))
        classes.append(mapped_row)

    print(classes)
    return classes

@app.post("/dashboard")
def dashboard(data: dict):
    dic = {}
    print(data['student_id'])
    query = 'select * from face.student where student_id = "'+ str(data['student_id']) +'"'
    cursor.execute(query)
    columns = [desc[0] for desc in cursor.description]
    results = cursor.fetchone() 
    student = dict(zip(columns, results))

    dic['student'] = student
    dic['upcomingClasses'] = upcomingClasses(data)
    return dic

@app.post("/getStudent")
def getStudent(data:dict):
    query = 'select * from face.student where student_id = "'+ str(data['student_id']) +'"'
    cursor.execute(query)
    columns = [desc[0] for desc in cursor.description]
    results = cursor.fetchone() 
    student = dict(zip(columns, results))
    print(student)
    return student

@app.post("/getStudentCourses")
def getStudentCourses(data: dict):
    print(data['student_id'])
    query = 'select * from face.course where course_id in (select course_id from face.istaking where student_id = "'+ str(data['student_id']) +'")'
    cursor.execute(query)
    columns = [desc[0] for desc in cursor.description]
    results = cursor.fetchall() 

    courses = []
    for row in results:
        mapped_row = dict(zip(columns, row))
        courses.append(mapped_row)

    print(courses)
    return courses


@app.post("/getCourse")
def getCourse(data: dict):
    print(data['course_id'])
    dic = {}
    query = 'select * from face.course where course_id = "'+ data['course_id'] +'"'
    cursor.execute(query)
    columns = [desc[0] for desc in cursor.description]
    results = cursor.fetchone() 
    course = dict(zip(columns, results))
    dic['course'] = course
    query = 'select * from face.teacher where role="instructor" and teacher_id in (select teacher_id from face.teaching where course_id = "'+ data['course_id'] +'")'
    cursor.execute(query)
    teachers =[]
    columns = [desc[0] for desc in cursor.description]
    results = cursor.fetchall() 
    print(results)
    for row in results:
        mapped_row = dict(zip(columns, row))
        teachers.append(mapped_row)
    dic['instructors'] = teachers

    query = 'select * from face.teacher where role="ta" and teacher_id in (select teacher_id from face.teaching where course_id = "'+ data['course_id'] +'")'
    cursor.execute(query)
    teachers =[]
    columns = [desc[0] for desc in cursor.description]
    results = cursor.fetchall() 
    print(results)
    for row in results:
        mapped_row = dict(zip(columns, row))
        teachers.append(mapped_row)
    dic['tas'] = teachers

    query = 'select * from face.note where note_type="lecture" and course_id = "'+ data['course_id'] +'" order by note_number'
    cursor.execute(query)
    lecture_notes =[]
    columns = [desc[0] for desc in cursor.description]
    results = cursor.fetchall() 
    print(results)
    for row in results:
        mapped_row = dict(zip(columns, row))
        lecture_notes.append(mapped_row)
    dic['lecture_notes'] = lecture_notes

    query = 'select * from face.note where note_type="tutorial" and course_id = "'+ data['course_id'] +'" order by note_number'
    cursor.execute(query)
    lecture_notes =[]
    columns = [desc[0] for desc in cursor.description]
    results = cursor.fetchall() 
    print(results)
    for row in results:
        mapped_row = dict(zip(columns, row))
        lecture_notes.append(mapped_row)
    dic['tutorial_notes'] = lecture_notes

    # print(dic)
    return dic

@app.post("/logout")
def logout(data: dict):
    print("hehehe")
    return {'logout': 'success'}


@app.post("/sendEmail")
async def sendEmail(data: dict):
    sender_email = "61aidar290802@gmail.com"  # Replace with your email address
    sender_password = "zuqt kqpo dixa bocc"  # Replace with your email password

    # Create a MIME message object
    message = MIMEMultipart()
    message["From"] = sender_email
    message["To"] = data['to']
    message["Subject"] = data['subject']

    # Attach the email body as plain text
    message.attach(MIMEText(data['body'], "html"))

    try:
        # Connect to the SMTP server
        with smtplib.SMTP("smtp.gmail.com", 587) as server:
            server.starttls()
            server.login(sender_email, sender_password)
            server.send_message(message)
            return {"message": "Email sent successfully."}
    except Exception as e:
        return {"message": str(e)}