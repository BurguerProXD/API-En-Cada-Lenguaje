use std::io::prelude::*;
use std::net::{TcpListener, TcpStream};
use std::time::{SystemTime, UNIX_EPOCH};

const IMAGENES: [&str; 5] = [
    "https://picsum.photos/800/600?random=700",
    "https://picsum.photos/800/600?random=701",
    "https://picsum.photos/800/600?random=702",
    "https://picsum.photos/800/600?random=703",
    "https://picsum.photos/800/600?random=704",
];

fn manejar_conexion(mut stream: TcpStream) {
    let mut buffer = [0; 1024];
    stream.read(&mut buffer).unwrap();

    let seed = SystemTime::now().duration_since(UNIX_EPOCH).unwrap().as_nanos();
    let idx = (seed % 5) as usize;
    let imagen = IMAGENES[idx];

    let respuesta = format!(
        "HTTP/1.1 200 OK\r\nContent-Type: application/json\r\n\r\n{{\"imagen_url\":\"{}\",\"estado\":\"ok\"}}",
        imagen
    );

    stream.write(respuesta.as_bytes()).unwrap();
    stream.flush().unwrap();
}

fn main() {
    let listener = TcpListener::bind("127.0.0.1:8088").unwrap();
    println!("API en Rust escuchando en http://localhost:8088");

    for stream in listener.incoming() {
        match stream {
            Ok(stream) => {
                std::thread::spawn(|| manejar_conexion(stream));
            }
            Err(e) => eprintln!("Error: {}", e),
        }
    }
}
