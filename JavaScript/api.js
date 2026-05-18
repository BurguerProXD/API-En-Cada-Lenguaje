const http = require('http');

const PORT = 8085;
const IMAGENES = [
    "https://picsum.photos/800/600?random=400",
    "https://picsum.photos/800/600?random=401",
    "https://picsum.photos/800/600?random=402",
    "https://picsum.photos/800/600?random=403",
    "https://picsum.photos/800/600?random=404"
];

const server = http.createServer((req, res) => {
    const imagenAleatoria = IMAGENES[Math.floor(Math.random() * IMAGENES.length)];
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ imagen_url: imagenAleatoria, estado: "ok" }));
});

server.listen(PORT, () => {
    console.log(`API en JavaScript escuchando en http://localhost:${PORT}`);
});
