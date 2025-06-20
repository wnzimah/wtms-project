<?php
ini_set('display_errors', 1);
error_reporting(E_ALL);

header('Content-Type: application/json');
include("dbconnect.php");

$submission_id = $_POST['submission_id'] ?? '';
$updated_text = $_POST['updated_text'] ?? '';

if (!$submission_id || !$updated_text) {
    echo json_encode(["status" => "failed", "data" => "Missing fields"]);
    exit();
}
$submission_id = intval($submission_id); // force integer

$sql = "UPDATE tbl_submissions SET submission_text = ?, submitted_at = NOW() WHERE id = ?";
$stmt = $conn->prepare($sql);

if (!$stmt) {
    echo json_encode([
        "status" => "failed",
        "data" => "❌ SQL ERROR: " . $conn->error,
        "query" => $sql
    ]);
    exit();
}

$stmt->bind_param("si", $updated_text, $submission_id);
if ($stmt->execute()) {
    echo json_encode(["status" => "success", "data" => "Submission updated"]);
} else {
    echo json_encode(["status" => "failed", "data" => "❌ Execute failed: " . $stmt->error]);
}
$conn->close();
?>
