// Compilar con: tsc api.ts && node api.js
// O ejecutar con: npx ts-node api.ts

import * as http from 'http';

const PORT: number = 8086;
const IMAGENES: string[] = [
    "https://picsum.photos/800/600?random=500",
    "https://picsum.photos/800/600?random=501",
    "https://picsum.photos/800/600?random=502",
    "https://picsum.photos/800/600?random=503",
    "https://picsum.photos/800/600?random=504"
];

const server = http.createServer((req: http.IncomingMessage, res: http.ServerResponse) => {
    const imagenAleatoria: string = IMAGENES[Math.floor(Math.random() * IMAGENES.length)];
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ imagen_url: imagenAleatoria, estado: "ok" }));
});

server.listen(PORT, () => {
    console.log(`API en TypeScript escuchando en http://localhost:${PORT}`);
});
