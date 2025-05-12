# wtms

A new Flutter project.
Worker Task Management System (WTMS)

A flutter PHP MySQL app where Workers can register, login and manage his profile.

 Information:

Code: STIWK2114 
Subject: Mobile Programming
Assignment: Assignment 2
NAME :WAN NUR AZIMAH BINTI WAN RAHMAT
MATRIC NUMBER:297976
Submission Date: 12 May 2025


 Description:
WTMS (Worker Task Management System) is a profile and task management application by workers. Allows employees to sign up​ / sign in and view their profile in a clean and responsive Flutter UI. The app would connect to a backend API made in PHP with a database in MySQL.

Features
1.Worker Registration
Workers can register with:
-Full Name
-Email
-Password (min 6 characters)
-Phone Number
-Address
The data is sent to a PHP backend through a secured HTTP POST.

2.Worker Login
Users need access to their email address and password to log in. The application validates credentials and displays worker profile in case of success.

3.Profile sreen
Show full worker information including:
-Worker ID
-Full Name
-Email
-Phone Number
-Address

Also includes an Logout button.

🔒 Secure Authentication

Password hashes are saved in the database with SHA1.


Session Persistence:
-A login session is stored using SharedPreferences.


## 🖼️ Screens Overview

### 1. **Registration Screen**
- **Fields**: Full Name, Email, Password, Phone Number, Address
- **Validations**: All fields required, email format checked, min password length 6

### 2. **Login Screen**
- **Fields**: Email, Password
- **On Success**: Full worker data passed to profile screen

### 3. **Profile Screen**
- **Displays**: Worker ID, Full Name, Email, Phone Number, Address
- **Action**: Logout button



⚙️ Tech Stack

| Layer        | Technology       |
|--------------|------------------|
| Frontend     | Flutter          |
| Backend API  | PHP              |
| Database     | MySQL            |
| Session Mgt  | SharedPreferences|
| Passwords    | SHA1 Hashing     



Github Link :(https://github.com/wnzimah/project-wtms-app.git)
YOUTUBE LINK : (https://youtu.be/AoQuPAxQTx8?si=Up9A6HgSSvS5k2by)