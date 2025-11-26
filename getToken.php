<?php
// get_token.php
session_start(); // Sessie hervatten om het token te lezen

header('Content-Type: application/json');

if (isset($_SESSION['spotify_access_token'])) {
    // Stuur het token (en wanneer het verloopt) als JSON
    echo json_encode([
        'access_token' => $_SESSION['spotify_access_token'],
        'expires_in' => $_SESSION['spotify_token_expires'] - time()
    ]);
} else {
    // Stuur een fout als de gebruiker niet is ingelogd
    http_response_code(401); // 401 = Unauthorized
    echo json_encode(['error' => 'Niet ingelogd']);
}
?>