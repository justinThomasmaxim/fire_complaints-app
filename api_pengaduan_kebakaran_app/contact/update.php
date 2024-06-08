<?php 

// Database connection
require '../config/connect_db.php';

// Allow CORS requests from any origin
header("Access-Control-Allow-Origin: *");
// Allow specific HTTP methods
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
// Allow specific HTTP headers
header("Access-Control-Allow-Headers: Content-Type, Authorization");


$id_kontak = $_POST['id_kontak'];
$no_tlp    = $_POST['no_tlp'];
$alamat    = $_POST['alamat'];

$query = "UPDATE kontak 
SET no_tlp = '$no_tlp', alamat = '$alamat'
WHERE id_kontak = '$id_kontak'
";

$result = mysqli_query($conn, $query);

// Fetch the data
if ($result) {
    echo json_encode(array("success"=>true));
} else {
    echo json_encode(array("success"=>false));
}

?>