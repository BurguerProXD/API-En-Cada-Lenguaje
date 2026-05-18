#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <time.h>

#define PORT 8080
#define BUFFER_SIZE 4096

const char *imagenes[] = {
    "https://picsum.photos/800/600?random=1",
    "https://picsum.photos/800/600?random=2",
    "https://picsum.photos/800/600?random=3",
    "https://picsum.photos/800/600?random=4",
    "https://picsum.photos/800/600?random=5"
};

void manejar_cliente(int cliente_socket) {
    char buffer[BUFFER_SIZE] = {0};
    read(cliente_socket, buffer, BUFFER_SIZE);

    srand(time(NULL));
    int idx = rand() % 5;
    char respuesta[BUFFER_SIZE];
    snprintf(respuesta, sizeof(respuesta),
        "HTTP/1.1 200 OK\r\nContent-Type: application/json\r\n\r\n"
        "{\"imagen_url\": \"%s\", \"estado\": \"ok\"}",
        imagenes[idx]);

    write(cliente_socket, respuesta, strlen(respuesta));
    close(cliente_socket);
}

int main() {
    int servidor_socket, cliente_socket;
    struct sockaddr_in direccion;
    int opt = 1;
    int addrlen = sizeof(direccion);

    servidor_socket = socket(AF_INET, SOCK_STREAM, 0);
    setsockopt(servidor_socket, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt));

    direccion.sin_family = AF_INET;
    direccion.sin_addr.s_addr = INADDR_ANY;
    direccion.sin_port = htons(PORT);

    bind(servidor_socket, (struct sockaddr *)&direccion, sizeof(direccion));
    listen(servidor_socket, 3);

    printf("API en C escuchando en http://localhost:%d\n", PORT);

    while (1) {
        cliente_socket = accept(servidor_socket, (struct sockaddr *)&direccion, (socklen_t*)&addrlen);
        manejar_cliente(cliente_socket);
    }
    return 0;
}
