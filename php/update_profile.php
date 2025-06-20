<?php
include 'dbconnect.php';
header('Content-Type: application/json');

// Ambil data dari POST
$worker_id = $_POST['worker_id'] ?? '';
$full_name = $_POST['full_name'] ?? '';
$email     = $_POST['email'] ?? '';
$phone     = $_POST['phone'] ?? '';
$address   = $_POST['address'] ?? '';

// Semakan ringkas
if (empty($worker_id) || empty($full_name) || empty($email)) {
    echo json_encode(["status" => "failed", "data" => "Missing fields"]);
    exit;
}

// SQL Update
$sql = "UPDATE workers SET full_name=?, email=?, phone=?, address=? WHERE id=?";
$stmt = $conn->prepare($sql);

if ($stmt) {
    $stmt->bind_param("ssssi", $full_name, $email, $phone, $address, $worker_id);
    $stmt->execute();
    $stmt->close();

    echo json_encode(["status" => "success", "data" => "Profile updated"]);
} else {
    echo json_encode(["status" => "failed", "data" => "SQL Error: " . $conn->error]);
}
?>
