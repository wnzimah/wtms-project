<?php
error_reporting(0);
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    sendJson(['status' => 'failed', 'data' => 'Invalid request method']);
    exit;
}

include_once "dbconnect.php";

/* ─── Ambil dan trim input ─── */
$full_name = trim($_POST['full_name'] ?? '');
$username  = trim($_POST['username']  ?? '');
$email     = trim($_POST['email']     ?? '');
$password  = trim($_POST['password']  ?? '');
$phone     = trim($_POST['phone']     ?? '');
$address   = trim($_POST['address']   ?? '');

/* ─── Semakan asas ─── */
if (!$full_name || !$username || !$email || !$password || !$phone || !$address) {
    sendJson(['status' => 'failed', 'data' => 'Missing required fields']);
    exit;
}

if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    sendJson(['status' => 'failed', 'data' => 'Invalid email format']);
    exit;
}

if (strlen($password) < 6) {
    sendJson(['status' => 'failed', 'data' => 'Password must be at least 6 characters']);
    exit;
}

/* ─── Pastikan username & email unik ─── */
$dupStmt = $conn->prepare("SELECT id FROM workers WHERE username = ? OR email = ? LIMIT 1");
$dupStmt->bind_param("ss", $username, $email);
$dupStmt->execute();
$dupStmt->store_result();

if ($dupStmt->num_rows > 0) {
    $dupStmt->close();
    sendJson(['status' => 'failed', 'data' => 'Username or email already taken']);
    exit;
}
$dupStmt->close();

/* ─── Hash password (SHA‑1 mengikut keperluan tugasan) ─── */
$hashed = sha1($password);

/* ─── Insert ─── */
$sql  = "INSERT INTO workers (full_name, username, email, password, phone, address)
         VALUES (?,?,?,?,?,?)";
$stmt = $conn->prepare($sql);
$stmt->bind_param("ssssss", $full_name, $username, $email, $hashed, $phone, $address);

if ($stmt->execute()) {
    sendJson(['status' => 'success', 'data' => null]);
} else {
    // Contoh kesilapan: duplicate key dari constraint UNIQUE
    sendJson(['status' => 'failed', 'data' => $stmt->error]);
}

$stmt->close();
$conn->close();

/* ─── Helper ─── */
function sendJson($arr) { echo json_encode($arr); }
?>
