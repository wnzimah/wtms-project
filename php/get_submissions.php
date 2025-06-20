<?php
ini_set('display_errors', 1);
error_reporting(E_ALL);
header('Content-Type: application/json');
include("dbconnect.php");
$worker_id = $_POST['worker_id'] ?? '';

if (!$worker_id) {
    echo json_encode(["status" => "failed", "data" => "Missing worker_id"]);
    exit();
}

$sql = "SELECT 
            s.id AS submission_id,
            s.work_id,
            w.title AS task_title,
            s.submission_text,
            DATE_FORMAT(s.submitted_at, '%Y-%m-%d %H:%i') AS submission_date
        FROM tbl_submissions s
        JOIN tbl_works w ON s.work_id = w.id
        WHERE s.worker_id = ?
        ORDER BY s.submitted_at DESC";
$stmt = $conn->prepare($sql);

if (!$stmt) {
    echo json_encode([
        "status" => "failed",
        "data" => "SQL Prepare Error: " . $conn->error
    ]);
    exit();
}

$stmt->bind_param("i", $worker_id);
$stmt->execute();
$result = $stmt->get_result();
$submissions = [];
while ($row = $result->fetch_assoc()) {
    $submissions[] = $row;
}

if (ob_get_length()) ob_clean();
if (!empty($submissions)) {
    echo json_encode(["status" => "success", "data" => $submissions]);
} else {
    echo json_encode(["status" => "failed", "data" => "No submission found"]);
}
$conn->close();
?>
