<?php
session_start();

if (isset($_SESSION['spotify_access_token'])) {
    echo json_encode(["loggedIn" => true]);
} else {
    echo json_encode(["loggedIn" => false]);
}
?>
