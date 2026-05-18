#include <iostream>
#include <string>
#include <sstream>
#include <cstring>
#include <cstdlib>
#include <ctime>
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>

#define PORT 8081

std::string obtener_imagen_aleatoria() {
    std::string imagenes[] = {
        "https://picsum.photos/800/600?random=10",
        "https://picsum.photos/800/600?random=20",
        "https://picsum.photos/800/600?random=30",
        "https://picsum.photos/800/600?random=40",
        "https://picsum.photos/800/600?random=50"
    };
    return imagenes[rand() % 5];
}

void manejar_cliente(int cliente_socket) {
    char buffer[4096] = {0};
    read(cliente_socket, buffer, 4096);

    std::string imagen = obtener_imagen_aleatoria();
    std::ostringstream respuesta;
    respuesta << "HTTP/1.1 200 OK\r\nContent-Type: application/json\r\n\r\n"
              << "{\"imagen_url\": \"" << imagen << "\", \"estado\": \"ok\"}";

    std::string resp_str = respuesta.str();
    send(cliente_socket, resp_str.c_str(), resp_str.length(), 0);
    close(cliente_socket);
}

int main() {
    srand(time(0));
    int servidor_socket = socket(AF_INET, SOCK_STREAM, 0);
    sockaddr_in direccion;
    direccion.sin_family = AF_INET;
    direccion.sin_port = htons(PORT);
    direccion.sin_addr.s_addr = INADDR_ANY;

    bind(servidor_socket, (sockaddr*)&direccion, sizeof(direccion));
    listen(servidor_socket, 3);

    std::cout << "API en C++ escuchando en http://localhost:" << PORT << std::endl;

    while (true) {
        int cliente_socket = accept(servidor_socket, nullptr, nullptr);
        manejar_cliente(cliente_socket);
    }
    close(servidor_socket);
    return 0;
}
