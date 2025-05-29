<?php
error_reporting(0);
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    sendJsonResponse(['status' => 'failed', 'data' => 'Invalid request method']);
    exit;
}

include_once("dbconnect.php");

$name = trim($_POST['full_name']);
$email = trim($_POST['email']);
$password = trim($_POST['password']);
$phone = trim($_POST['phone']);
$address = trim($_POST['address']);

if (empty($name) || empty($email) || empty($password) || empty($phone) || empty($address)) {
    sendJsonResponse(['status' => 'failed', 'data' => 'Missing required fields']);
    exit;
}

if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    sendJsonResponse(['status' => 'failed', 'data' => 'Invalid email format']);
    exit;
}

if (strlen($password) < 6) {
    sendJsonResponse(['status' => 'failed', 'data' => 'Password must be at least 6 characters']);
    exit;
}

// Hash with SHA1 (per assignment requirement)
$hashed_password = sha1($password);

$sql = "INSERT INTO workers (full_name, email, password, phone, address) VALUES (?, ?, ?, ?, ?)";
$stmt = $conn->prepare($sql);
$stmt->bind_param("sssss", $name, $email, $hashed_password, $phone, $address);

if ($stmt->execute()) {
    sendJsonResponse(['status' => 'success', 'data' => null]);
} else {
    sendJsonResponse(['status' => 'failed', 'data' => $stmt->error]);
}

$stmt->close();
$conn->close();

function sendJsonResponse($array)
{
    echo json_encode($array);
}
?>
