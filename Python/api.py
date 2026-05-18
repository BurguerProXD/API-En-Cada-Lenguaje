import http.server
import json
import random
import socketserver

PORT = 8083
IMAGENES = [
    "https://picsum.photos/800/600?random=200",
    "https://picsum.photos/800/600?random=201",
    "https://picsum.photos/800/600?random=202",
    "https://picsum.photos/800/600?random=203",
    "https://picsum.photos/800/600?random=204"
]

class Manejador(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-Type", "application/json")
        self.end_headers()
        respuesta = {"imagen_url": random.choice(IMAGENES), "estado": "ok"}
        self.wfile.write(json.dumps(respuesta).encode())

    def log_message(self, format, *args):
        pass

with socketserver.TCPServer(("", PORT), Manejador) as httpd:
    print(f"API en Python escuchando en http://localhost:{PORT}")
    httpd.serve_forever()
