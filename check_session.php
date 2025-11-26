<?php
// check_session.php
// Dit script start de sessie en kijkt wat erin zit.

session_start(); // Cruciaal! Anders kun je de sessie niet lezen.

header('Content-Type: text/plain'); // Maak het makkelijk leesbaar

if (isset($_SESSION['spotify_access_token'])) {
    echo "--- SUCCES! --- \n\n";
    echo "Er is een token gevonden in de PHP-sessie.\n\n";
    
    // We tonen alleen de eerste 15 tekens (veiliger)
    echo "Access Token (start met): " . substr($_SESSION['spotify_access_token'], 0, 15) . "...\n";
    echo "Refresh Token (start met): " . substr($_SESSION['spotify_refresh_token'], 0, 15) . "...\n";
    
    // We kunnen ook checken wanneer het verloopt
    $verlooptOver = $_SESSION['spotify_token_expires'] - time();
    echo "Token is nog (ongeveer) " . $verlooptOver . " seconden geldig.";

} else {
    echo "--- FOUT --- \n\n";
    echo "Er is GEEN token gevonden in de PHP-sessie.\n";
    echo "Ben je al ingelogd via login.php?";
}
?>