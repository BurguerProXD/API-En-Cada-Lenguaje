// Usar Swift Package Manager con SwiftNIO o implementación pura con sockets Darwin/Glibc
// Este ejemplo usa solo Foundation y sockets POSIX

import Foundation
import Glibc  // en Linux, o Darwin en macOS

let PORT: UInt16 = 8090
let IMAGENES = [
    "https://picsum.photos/800/600?random=1000",
    "https://picsum.photos/800/600?random=1001",
    "https://picsum.photos/800/600?random=1002",
    "https://picsum.photos/800/600?random=1003",
    "https://picsum.photos/800/600?random=1004"
]

func createSocket() -> Int32 {
    let sock = socket(AF_INET, Int32(SOCK_STREAM.rawValue), 0)
    var opt: Int32 = 1
    setsockopt(sock, SOL_SOCKET, SO_REUSEADDR, &opt, socklen_t(MemoryLayout<Int32>.size))
    return sock
}

func startServer() {
    let sock = createSocket()
    var addr = sockaddr_in(
        sin_family: sa_family_t(AF_INET),
        sin_port: PORT.bigEndian,
        sin_addr: in_addr(s_addr: INADDR_ANY),
        sin_zero: (0, 0, 0, 0, 0, 0, 0, 0)
    )

    withUnsafePointer(to: &addr) {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
            bind(sock, $0, socklen_t(MemoryLayout<sockaddr_in>.size))
        }
    }
    listen(sock, 3)
    print("API en Swift escuchando en http://localhost:\(PORT)")

    while true {
        let client = accept(sock, nil, nil)
        let imagen = IMAGENES[Int.random(in: 0..<IMAGENES.count)]
        let json = "{\"imagen_url\":\"\(imagen)\",\"estado\":\"ok\"}"
        let response = "HTTP/1.1 200 OK\r\nContent-Type: application/json\r\n\r\n\(json)"
        response.withCString { send(client, $0, strlen($0), 0) }
        close(client)
    }
}

startServer()
