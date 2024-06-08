<?php 

// Database connection
require '../config/connect_db.php';

// Allow CORS requests from any origin
header("Access-Control-Allow-Origin: *");
// Allow specific HTTP methods
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
// Allow specific HTTP headers
header("Access-Control-Allow-Headers: Content-Type, Authorization");

// Check if id_laptop is set and is a number
if (isset($_POST['id_kontak']) && is_numeric($_POST['id_kontak'])) {
    $id_kontak = intval($_POST['id_kontak']);

    // Query to select data
    $query = "SELECT * FROM kontak
    WHERE id_kontak = $id_kontak;";
    $result = mysqli_query($conn, $query);
    $rows = [];

    // Fetch the data
    if ($result) {
        while ($row = mysqli_fetch_assoc($result)) {
            $rows[] = $row;
        }
        // Return the data as JSON
        echo json_encode($rows);
    } else {
        echo json_encode(["error" => "Query failed: " . mysqli_error($conn)]);
    }
} else {
    echo json_encode(["error" => "Invalid id_kontak"]);
}

?>