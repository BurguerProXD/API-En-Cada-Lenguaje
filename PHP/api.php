<?php
$imagenes = [
    "https://picsum.photos/800/600?random=800",
    "https://picsum.photos/800/600?random=801",
    "https://picsum.photos/800/600?random=802",
    "https://picsum.photos/800/600?random=803",
    "https://picsum.photos/800/600?random=804"
];

$imagenAleatoria = $imagenes[array_rand($imagenes)];
header('Content-Type: application/json');
echo json_encode([
    "imagen_url" => $imagenAleatoria,
    "estado" => "ok"
]);
