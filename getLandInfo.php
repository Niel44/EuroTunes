<?php
require 'config.php';
// 1. Haal de landcode op uit de URL (bijv. getLandInfo.php?code=NL)
if (empty($_GET['code'])) {
    die(json_encode(['error' => 'Geen landcode opgegeven.']));
}
$land_code = $_GET['code'];

$conn = new mysqli($servername, $username, $password, $dbname);

// 3. Check verbinding
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// 4. Haal data op (gebruik prepared statements tegen SQL-injection!)
$stmt = $conn->prepare("SELECT naam, hoofdstad, vlag_url, info_tekst FROM landen WHERE land_code = ?");
$stmt->bind_param("s", $land_code);
$stmt->execute();
$result = $stmt->get_result();
$data = $result->fetch_assoc();

// 5. Stuur data terug als JSON
header('Content-Type: application/json');
if ($data) {
    echo json_encode($data);
} else {
    // Stuur een duidelijke JSON-fout terug als het land niet in de DB staat
    echo json_encode(['error' => 'Dat land staat (nog) niet in de database.']);
}

$stmt->close();
$conn->close();
?>