# wtms

# Worker Task Management System (WTMS)
_____________________________________________________

Code: STIWK2114 

Subject: Mobile Programming

NAME :WAN NUR AZIMAH BINTI WAN RAHMAT

MATRIC NUMBER:297976


 # Project Description:
 _____________________________

    -A task management and profile app for employees is called WTMS (Worker Task Management System). Through a simple and responsive Flutter interface, it enables worker members to register or log in, examine tasks that have been allocated to them, and submit work completion reports. 

    -The app would connect to a backend API made in PHP with a database in MySQL.


# Getting Started by:
________________________________

    1.Download this repository or clone it.
    2.Create the necessary workers table and configure your MySQL database.
    3.Modify the Flutter configuration (config.dart) and PHP files to correspond with your local server configuration.
    4.Use a hardware device or an emulator to run the Flutter project.


  # Tech Stack ⚙️
__________________________________

    Frontend :Flutter
    Backend API: PHP
    Database :MySQL
    State & Auth : SharedPreferences
    Security: SHA1 Password Hashing
 

# Features App ✨
____________________________________

1. Worker Registration
    Workers can register with:
    -Full Name
    -Email
    -Password (min 6 characters)
    -Phone Number
    -Address
    The data is sent to a PHP backend through a secured HTTP POST.

2. Worker Login
    -Employees input their password and email.
    -Worker info is sent to the Profile screen upon success.
    -For security, passwords are SHA1 hashed in the backend.

3. Profile sreen
    Show full worker information including:
    -Worker ID
    -Full Name
    -Email
    -Phone Number
    -Address
    -ALso includes buttons for My Tasks and Logout.

4.  Assigned task screen
    All of the task assigned to the logged-in worker are listed on this screen (based on assigned_to ID).

    Every card displays:
    -Title
    -An explanation
    -Date of Due
    -Color-coded status badges: Pending, Completed, and Overdue

5. Submit work screen
    -Any pending task can be tapped by worker to bring up the submission screen.
    -"What did you complete?" is a text area that the user need fills out.
    
    After submission:
    -Tbl_submissions is where the data is stored.-App updates on the status of the task to be complete.
    -The user is returned to the most recent task list.



 # Screens Overview 🖼️
_____________________________

📄 Registration Screen
    -Fields: Name, Email, Password, Phone, Address
    -Validations: Required fields, valid email, min 6-char password

🔐 Login Screen
    -Fields: Email, Password
    -Success: Redirects to profile with full data

👤 Profile Screen
    -Shows user data
    -Buttons: My Tasks, Logout

📋 Task List
    -Shows only tasks assigned to the worker
    -Color-coded status labels
    -Tap to submit work

✍️ Submit Work
    -Prefilled task title and description
    -Text field for completion note
    -Submit button with validation

🔒 Secure Authentication
    Password hashes are saved in the database with SHA1.

# Link ✨
__________________________

GitHub Link
    https://github.com/wnzimah/wtms-project.git

YOUTUBE LINK 

    Phase 1 : 
    https://youtu.be/AoQuPAxQTx8?si=Up9A6HgSSvS5k2by

    Phase 2 ,Task Completion System:
    https://youtu.be/1qvjaIUDGUI?si=y641ccvB0BTC1A5O
    