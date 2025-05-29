<?php
error_reporting(0);
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(["status" => "failed", "data" => "Invalid request method"]);
    exit;
}

include_once("dbconnect.php");

$worker_id = $_POST['worker_id'];

$sql = "SELECT * FROM tbl_works WHERE assigned_to = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $worker_id);
$stmt->execute();
$result = $stmt->get_result();

$works = [];

if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $works[] = $row;
    }
    echo json_encode(["status" => "success", "data" => $works]);
} else {
    echo json_encode(["status" => "failed", "data" => "No tasks found"]);
}
?>
