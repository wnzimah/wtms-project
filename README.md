
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

1. **Worker Registration**  
   Workers can register with:
   - Full Name  
   - Email  
   - Password (min 6 characters)  
   - Phone Number  
   - Address  
   The data is sent to a PHP backend through a secured HTTP POST.

2. **Worker Login**  
   Employees input their password and email.  
   - Worker info is sent to the Profile screen upon success.  
   - For security, passwords are SHA1 hashed in the backend.

3. **Profile Screen**  
   Shows full worker information including:  
   - Worker ID  
   - Full Name  
   - Email  
   - Phone Number  
   - Address  
   Also includes buttons for **My Tasks** and **Logout**.

4. **Assigned Task Screen**  
   Displays all tasks assigned to the logged-in worker.

   Each task card displays:
   - Title  
   - Explanation  
   - Due Date  
   - Color-coded badges: **Pending**, **Completed**, **Overdue**

5. **Submit Work Screen**  
   Any pending task can be tapped to submit work.

   - Workers fill out a text area: _"What did you complete?"_
   - After submission, data is stored in `tbl_submissions`
   - App auto-updates the task status to **Completed**
   - User is returned to the updated task list


 # Screens Overview 🖼️
_____________________________

### Registration Screen
- **Fields:** Name, Email, Password, Phone, Address  
- **Validations:** Required fields, valid email format, minimum 6-character password  
- **Backend:** Sends data securely to PHP backend via HTTP POST

###  Login Screen
- **Fields:** Email, Password  
- **Process:** On success, redirects to Profile Screen with full user data  

###  Profile Screen
- **Displays:** Full user details (ID, Name, Email, Phone, Address)  
- **Actions:** Buttons for:
  - 🗂️ *My Tasks*  
  - 🚪 *Logout*

### Task List Screen
- **Displays:** Tasks assigned to the logged-in worker only  
- **Card Contents:**  
  - Title  
  - Description  
  - Due Date  
  - **Color-coded status:**  
    - 🟡 Pending  
    - ✅ Completed  
    - 🔴 Overdue  
- **Action:** Tap a task to open the submission form

### Submit Work Screen
- **Prefilled Info:** Task title and description  
- **Input Field:** Completion note from worker  
- **Validation:** Ensures field is not empty  
- **After Submission:**  
  - Saves data to `tbl_submissions`  
  - Updates task status to **Completed**  
  - Returns to latest task list

### Secure Authentication 
- **Passwords:** SHA1-hashed before storing in database  
- **Data:** Sent securely to backend via HTTP POST

---


##  Project Links 🔗

### GitHub Repository  
   [wtms-project (GitHub)](https://github.com/wnzimah/wtms-project.git)

### YouTube Demonstration

- **Phase 1 – User Registration & Login**  
    (https://youtu.be/AoQuPAxQTx8?si=Up9A6HgSSvS5k2by)

- **Phase 2 – Task Completion System**  
    (https://youtu.be/1qvjaIUDGUI?si=y641ccvB0BTC1A5O)
