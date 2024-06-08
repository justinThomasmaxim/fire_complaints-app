<?php 

// Database connection
require '../config/connect_db.php';

// Allow CORS requests from any origin
header("Access-Control-Allow-Origin: *");
// Allow specific HTTP methods
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
// Allow specific HTTP headers
header("Access-Control-Allow-Headers: Content-Type, Authorization");



$username = $_POST['username'];
$password = $_POST['password'];
$nama     = $_POST['nama'];
$no_tlp   = $_POST['no_tlp'];

$query = "INSERT INTO pengguna(username, password, nama, no_tlp)
VALUES ('$username', '$password', '$nama', '$no_tlp')";

$result = mysqli_query($conn, $query);

// Fetch the data
if ($result) {
    echo json_encode(array("success"=>true));
} else {
    echo json_encode(array("success"=>false));
}

mysqli_close($conn);


?>