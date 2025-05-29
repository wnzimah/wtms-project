<?php
error_reporting(0);
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    sendJsonResponse(['status' => 'failed', 'data' => 'Invalid request method']);
    exit;
}

include_once("dbconnect.php");

$email = trim($_POST['email']);
$password = trim($_POST['password']);
$hashed_password = sha1($password);

$sql = "SELECT * FROM workers WHERE email = ? AND password = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("ss", $email, $hashed_password);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $worker = $result->fetch_assoc();
    $response = array('status' => 'success', 'data' => [$worker]);
} else {
    $response = array('status' => 'failed', 'data' => null);
}

sendJsonResponse($response);

function sendJsonResponse($array)
{
    echo json_encode($array);
}
?>
