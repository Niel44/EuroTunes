<?php
// callback.php — Spotify Authorization Code Flow Callback
session_start();
require 'config.php';

// 1️⃣ Controleer of er een code is meegegeven
if (!isset($_GET['code'])) {
    die("Geen autorisatiecode ontvangen van Spotify.");
}

$code = $_GET['code'];

// 2️⃣ Bouw de token-aanvraag
$authHeader = base64_encode($spotifyClientId . ':' . $spotifyClientSecret);

$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, 'https://accounts.spotify.com/api/token');
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_POST, true);
curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query([
    'grant_type' => 'authorization_code',
    'code' => $code,
    'redirect_uri' => 'https://i580580.hera.fontysict.net/EuroTunes/callback.php' // ✅ exact zelfde als login.php
]));
curl_setopt($ch, CURLOPT_HTTPHEADER, [
    'Authorization: Basic ' . $authHeader,
    'Content-Type: application/x-www-form-urlencoded'
]);

$result = curl_exec($ch);
curl_close($ch);

$tokenData = json_decode($result);

// 3️⃣ Controleer op fouten
if (isset($tokenData->error)) {
    die("Spotify fout: " . htmlspecialchars($tokenData->error_description ?? $tokenData->error));
}

if (!isset($tokenData->access_token)) {
    die("Kon geen access token ophalen van Spotify. Response: " . htmlspecialchars($result));
}

// 4️⃣ Sla tokens op in de sessie
$_SESSION['spotify_access_token'] = $tokenData->access_token;
$_SESSION['spotify_refresh_token'] = $tokenData->refresh_token ?? null;
$_SESSION['spotify_token_expires'] = time() + ($tokenData->expires_in ?? 3600);

// 5️⃣ Redirect naar je hoofdpagina
header('Location: index.html');
exit;
?>
