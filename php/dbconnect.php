<?php
$servername = "localhost";
$username = "root";  // default username for MySQL in XAMPP
$password = "";      // default password for MySQL in XAMPP (empty)
$dbname = "wtms_db";  // database name

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>
