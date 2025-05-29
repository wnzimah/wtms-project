<?php
error_reporting(0);
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    sendJsonResponse(['status' => 'failed', 'data' => 'Invalid request method']);
    exit;
}

include_once("dbconnect.php");

$work_id = $_POST['work_id'];
$worker_id = $_POST['worker_id'];
$submission_text = addslashes($_POST['submission_text']);
$submitted_at = date("Y-m-d H:i:s");


$sql = "INSERT INTO tbl_submissions (work_id, worker_id, submission_text, submitted_at)
        VALUES ('$work_id', '$worker_id', '$submission_text', '$submitted_at')";

if ($conn->query($sql) === TRUE) {
    
    $update = "UPDATE tbl_works SET status = 'completed' WHERE id = '$work_id'";
    $conn->query($update);

    sendJsonResponse(['status' => 'success', 'data' => null]);
} else {
    sendJsonResponse(['status' => 'failed', 'data' => $conn->error]);
}

function sendJsonResponse($array)
{
    echo json_encode($array);
}
?>
