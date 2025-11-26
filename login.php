<?php
// login.php — Spotify Authorization Code Flow

session_start();
require 'config.php'; // bevat $spotifyClientId en eventueel $spotifyClientSecret

// 1️⃣ Controleer of de Client ID is ingesteld
if (empty($spotifyClientId)) {
    die("<b>FATALE FOUT:</b> <code>\$spotifyClientId</code> is leeg. Controleer je <code>config.php</code> bestand.");
}

// 2️⃣ Definieer de vereiste scopes
$scopes = [
    'streaming', 
    'user-read-email', 
    'user-read-private',
    'user-read-playback-state',
    'user-modify-playback-state',
    'user-library-read', 
    'user-library-modify'
];

// 3️⃣ Bouw de echte Spotify authorize URL
$authorize_url = 'https://accounts.spotify.com/authorize?' . http_build_query([
    'response_type' => 'code',
    'client_id' => $spotifyClientId,
    'scope' => implode(' ', $scopes),
    'redirect_uri' => 'http://127.0.0.1:80/EuroTunes/callback.php', // moet exact overeenkomen met wat je in Spotify Dashboard hebt opgegeven
]);

// 4️⃣ Stuur de gebruiker door naar Spotify’s loginpagina
header('Location: ' . $authorize_url);
exit;
?>
