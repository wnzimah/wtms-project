<?php
include("dbconnect.php");
header('Content-Type: application/json');

$worker_id = $_POST['worker_id'] ?? '';

if (!$worker_id) {
    echo json_encode(["status" => "failed", "data" => "worker_id missing"]);
    exit;
}

$sql = "SELECT id AS worker_id,
               username,          
               full_name,
               email,
               phone,
               address
        FROM workers
        WHERE id = ?";

$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $worker_id);
$stmt->execute();
$result = $stmt->get_result();

if ($row = $result->fetch_assoc()) {
    echo json_encode(["status" => "success", "data" => $row]);
} else {
    echo json_encode(["status" => "failed", "data" => "No user found"]);
}

$conn->close();
?>
