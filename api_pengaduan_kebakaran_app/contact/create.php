<?php 

// Database connection
require '../config/connect_db.php';

// Allow CORS requests from any origin
header("Access-Control-Allow-Origin: *");
// Allow specific HTTP methods
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
// Allow specific HTTP headers
header("Access-Control-Allow-Headers: Content-Type, Authorization");



$id_pengguna = $_POST['id_pengguna'];
$no_tlp      = $_POST['no_tlp'];
$alamat      = $_POST['alamat'];


$query = "INSERT INTO kontak (id_pengguna, no_tlp, alamat)
VALUES ('$id_pengguna', '$no_tlp', '$alamat')";

$result = mysqli_query($conn, $query);

// Fetch the data
if ($result) {
    echo json_encode(array("success"=>true));
} else {
    echo json_encode(array("success"=>false));
}

mysqli_close($conn);


?>