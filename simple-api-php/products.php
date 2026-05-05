<?php
header("Content-Type: application/json");

// I nostri dati di esempio
$products = [
    ["id" => 1, "name" => "Mela", "price" => 0.5],
    ["id" => 2, "name" => "Banana", "price" => 0.3],
    ["id" => 3, "name" => "Arancia", "price" => 0.7]
];

$method = $_SERVER["REQUEST_METHOD"];
$id = isset($_GET['id']) ? (int)$_GET['id'] : null;

switch ($method) {
    case "GET":
        // Se c'è un ID, cerchiamo il singolo prodotto, altrimenti tutti
        if ($id) {
            $foundProduct = null;
            foreach ($products as $p) {
                if ($p['id'] === $id) {
                    $foundProduct = $p;
                    break;
                }
            }
            if ($foundProduct) {
                echo json_encode($foundProduct);
            } else {
                http_response_code(404);
                echo json_encode(["error" => "Prodotto non trovato"]);
            }
        } else {
            echo json_encode($products);
        }
        break;

    case "POST":
        $input = json_decode(file_get_contents("php://input"), true);
        if (isset($input["name"], $input["price"])) {
            $newProduct = [
                "id" => count($products) + 1,
                "name" => $input["name"],
                "price" => $input["price"]
            ];
            http_response_code(201); // Created
            echo json_encode(["message" => "Prodotto aggiunto", "product" => $newProduct]);
        } else {
            http_response_code(400); // Bad Request
            echo json_encode(["error" => "Dati non validi"]);
        }
        break;

    case "PUT":
        if ($id) {
            $input = json_decode(file_get_contents("php://input"), true);
            // Similiamo l'aggiornamento
            http_response_code(200);
            echo json_encode([
                "message" => "Prodotto $id aggiornato",
                "data_ricevuta" => $input
            ]);
        } else {
            http_response_code(400);
            echo json_encode(["error" => "ID mancante"]);
        }
        break;

    case "DELETE":
        if ($id) {
            // Qui andrebbe la logica per rimuovere l'elemento dall'array/DB
            http_response_code(200);
            echo json_encode(["message" => "Prodotto $id eliminato con successo"]);
        } else {
            http_response_code(400);
            echo json_encode(["error" => "ID mancante"]);
        }
        break;

    default:
        http_response_code(405);
        echo json_encode(["error" => "Metodo non supportato"]);
        break;
}
?>
