<?php
// getTop10.php (V2 - Gebruikt de Gebruikers-Sessie)

session_start(); // Hervat de sessie om het token te lezen
require 'config.php'; // We hebben de landnamen nodig

// --- DEEL 1: HAAL HET GEBRUIKERSTOKEN UIT DE SESSIE ---
if (!isset($_SESSION['spotify_access_token'])) {
    die(json_encode(["error" => "Gebruiker is niet ingelogd (geen token in sessie)."]));
}
$accessToken = $_SESSION['spotify_access_token'];

// --- DEEL 2: VERTALING LANDCODE NAAR NAAM (Werkt al) ---
$land_code = strtoupper($_GET['code'] ?? 'GLOBAL');
$land_namen = [
    'NL' => 'Netherlands', 'BE' => 'Belgium', 'DE' => 'Germany',
    'FR' => 'France',       'GB' => 'UK',      'ES' => 'Spain',
    'IT' => 'Italy',        'SE' => 'Sweden',
];
$land_naam = $land_namen[$land_code] ?? 'Global';
$zoek_term = "Top 50 " . $land_naam;

// --- DEEL 3: OFFICIËLE SPOTIFY PLAYLIST-IDS PER LAND ---
$top50_playlists = [
    'NL' => '1O6G4A9nY31aCZvnr60RnQ', // Netherlands
    'DE' => '3MetLFKQz4usZQ8BHh1geN', // Germany 
    'PL' => '0wvah17d4DYfgOukygOyzp', // Polen
    'TR' => '0noBG6tjUn98EWmbnB2txs', // Turkije
    'GB' => '4R68pfdZb8Ney3pxeIx2hK', // Verenigd Koninkrijk
    'EU' => '3VnXjIZot8NaGCDd3PBF6t', // Global
    'AT' => '4uQPOAavcjjQb11d3A3E0R', // Oostenrijk
    'BE' => '0ACaFBxdcISIfkYQCgjHxU', // België
    'BG' => '1yPHiM183S2xYK7Oe1JGsm', // Bulgarije
    'CZ' => '6iMvdvzQdr8mYUBekm94EW', // Tsjechië
    'DK' => '3AFdpZFuy7Yvt1Hcwq0dn6', // Denemarken
    'HU' => '5Kbnv2UpBxIaI4GJO43pO3', // Hongarije
    'IE' => '3XwNJMaAKOPLWkp1ZfErS6', // Ierland
    'LV' => '2huvUhz4IBasG1xM9pSTgw', // Letland
    'LT' => '71KhgkHhkNIbn00QxvLZYU', // Litouwen
    'LU' => '6kOKhUCng9xZOFcjEPU1l8', // Luxemburg
    'NO' => '0NVuLDD0A1hZhN91805PFI', // Noorwegen
    'PT' => '6A7D1qxF7uS2E08ucjcAVn', // Portugal
    'RO' => '683mlvH4i9WFKbG4JgzlKt', // Roemenië
    'SK' => '3PovYU9gGQEc4QbXU1Eu1t', // Slowakije
    'ES' => '7493Y6RuZN2MYV4CHrdIrA', // Spanje
    'CH' => '6R4eoEEGxAf1hRhTmekcqO', // Zwitserland
    'LI' => '6R4eoEEGxAf1hRhTmekcqO', // Liechtenstein
    'FI' => '011NdaHKl5ZHfrZhnAiJBS', // Finland
    'FR' => '0ajDM2uTRRjN4Lkf3VnaxM', // Frankrijk
    'AD' => '0ajDM2uTRRjN4Lkf3VnaxM', // Andorra
    'MC' => '0ajDM2uTRRjN4Lkf3VnaxM', // Monaco
    'GR' => '49CZ8xX6otkMq51JxO2rkU', // Griekenland
    'IS' => '5ZT5INf2C3u98tawxFG6O0', // IJsland
    'IT' => '6rgFXsI9FelHAapkkU0yKp', // Italië
    'VA' => '6rgFXsI9FelHAapkkU0yKp', // Vaticaanstad
    'SM' => '6rgFXsI9FelHAapkkU0yKp', // San Marino
    'MT' => '4WjFebOW47AKnTERpmbZLL', // Malta
    'RU' => '4rkFHpOvKPXA6OAxSrUro3', // Rusland
    'SE' => '5Da4F7EsyklLlgPky35BgV', // Zweden
    'UA' => '5oEHKxJ2c4W9zEiFSK1gNH', // Oekraïne
    'AL' => '2bK4QmR6TFHcesZNBnWpZT', // Albanië
    'AM' => '5gHR8aj3itCt3LK9NkmaYN', // Armenië
    'AZ' => '7w0cgtJdRbPBvYaTPQyifU', // Azerbeidzjan
    'BA' => '2en8N6OWKCq93WjCA2sgLD', // Bosnië en Herzegovina
    'CY' => '1NNauN205jiVeH2ixReshi', // Cyprus
    'EE' => '4MyhUEdMzbgVRby3hsqhnO', // Estland
    'GE' => '7LtHsfPd6oBt4geY40BTpU', // Georgië
    'HR' => '1iqFmUPFuPpBVgvrWccMVW', // Kroatië
    'MD' => '6XunFF5qlaikThDjW8XLxK', // Moldavië
    'ME' => '59Em8Zqcw60fh1rgNFy4ag', // Montenegro
    'MK' => '6wk61XRax6dMvX3WClLYbH', // Noord-Macedonië
    'RS' => '4lNKrQuO4j1P7PS3duC1Ov', // Servië
    'SI' => '4lNKrQuO4j1P7PS3duC1Ov', // Slovenië
    'KZ' => '0gkl8tBwDkw5yKzM0ukWVy', // Kazachstan
    'XK' => '3VnXjIZot8NaGCDd3PBF6t', // Kosovo

];

$playlist_id = $top50_playlists[$land_code] ?? $top50_playlists['GLOBAL'];

// --- DEEL 4: HAAL DE TRACKS OP ---
// We willen SORTEREN op added_at → dus limit hoog zetten
$fields = "items(added_at,track(name,artists(name),uri,album(images)))";
$tracksUrl = "https://api.spotify.com/v1/playlists/" . $playlist_id . "/tracks?limit=50&fields=" . $fields;

$ch_tracks = curl_init();
curl_setopt($ch_tracks, CURLOPT_URL, $tracksUrl);
curl_setopt($ch_tracks, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch_tracks, CURLOPT_HTTPHEADER, ['Authorization: Bearer ' . $accessToken]);
$tracksResult = curl_exec($ch_tracks);
curl_close($ch_tracks);

$playlistData = json_decode($tracksResult, true);

if (!isset($playlistData['items'])) {
    die(json_encode(["error" => "Kon 'items' niet vinden in de playlist."]));
}

// SORTEREN: nieuwste eerst
usort($playlistData['items'], function($a, $b) {
    return strtotime($b['added_at']) - strtotime($a['added_at']);
});

// Alleen top 10 terugsturen
header('Content-Type: application/json');
echo json_encode(array_slice($playlistData['items'], 0, 10));


?>