
# Worker Task Management System (WTMS)
_____________________________________________________

Code: STIWK2114 

Subject: Mobile Programming

NAME :WAN NUR AZIMAH BINTI WAN RAHMAT

MATRIC NUMBER:297976


 # Project Description:
 _____________________________

    - A task‑management and profile app for employees called **WTMS (Worker Task Management System)**.  
   Through a simple and responsive **Flutter interface**, it enables workers to:  
   - Register or log in  
   - View tasks assigned to them  
   - Submit work‑completion reports  
   - View & edit previous submissions  
   - Update their profile  

   - The app connects to a **backend API built in PHP**, with a **MySQL** database to store all data securely.



# Getting Started by:
________________________________

    1.Download this repository or clone it.
    2.Import the provided wtms.sql file to create workers, tbl_works, and tbl_submissions tables (with sample data).
    3.Modify the Flutter configuration (config.dart) and PHP files to correspond with your local server configuration.
    4.Use a hardware device or an emulator to run the Flutter project.
    ```bash
      cd flutter
      flutter pub get
      flutter run


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
   - username
   - Email  
   - Password (min 6 characters)  
   - Phone Number  
   - Address  
   The data is sent to a PHP backend through a secured HTTP POST.

2. **Worker Login**  
   Employees input their password and email.  
   - Worker info is sent to the Profile screen upon success.  
   - Ater login user redirected to Assigned Task screen.
   - For security, passwords are SHA1 hashed in the backend.


3. **Profile Screen**  
   Shows full worker information including:  
   - Worker ID  
   - Full Name 
   - username  
   - Email  
   - Phone Number  
   - Address  
   Also includes buttons for **Edit profile**.
  
   **Edit Profile Button**
    Allows editing of:
  - Full Name
  - Email
  - Phone
  - Address
   * **Username** remains locked (non-editable)
   * Profile data saved to backend via `update_profile.php`

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

   6. **Submission History Screen**  

   - List of past submissions (task title, date, preview).
   - User need to tap to edit any submission.
   - Update previous text, confirm overwrite.
   - Confirmation dialog will appear asking the user to confirm their update submission.
   - Success update snackbar shown.

   
6. **Navigation**  

   - Drawer Navigation Bar with 3 tabs , assigned task, submission history, my profile.



##  Project Links 🔗
  [LAB 2 ASSIGMENT YOUTUBE] (https://www.youtube.com/watch?v=AoQuPAxQTx8)
   [MIDTERM ASSIGMENT YOUTUBE] (https://www.youtube.com/watch?v=1qvjaIUDGUI)
   [FINAL ASSIGMENT YOUTUBE] (https://youtu.be/GFx-iY3f0Os?si=QRUuaofjOdP7xZck)

### GitHub Repository  
   [wtms-project (GitHub)](https://github.com/wnzimah/wtms-project.git)
 

