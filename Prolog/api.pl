:- use_module(library(socket)).

port(8100).
imagenes([
    "https://picsum.photos/800/600?random=2000",
    "https://picsum.photos/800/600?random=2001",
    "https://picsum.photos/800/600?random=2002",
    "https://picsum.photos/800/600?random=2003",
    "https://picsum.photos/800/600?random=2004"
]).

api :-
    port(P),
    tcp_socket(ServerSocket),
    tcp_setopt(ServerSocket, reuseaddr),
    tcp_bind(ServerSocket, localhost:P),
    tcp_listen(ServerSocket, 5),
    format('API en Prolog escuchando en http://localhost:~w~n', [P]),
    aceptar_conexiones(ServerSocket).

aceptar_conexiones(ServerSocket) :-
    tcp_accept(ServerSocket, ClientSocket, _Peer),
    thread_create(manejar_cliente(ClientSocket), _, [detached(true)]),
    aceptar_conexiones(ServerSocket).

manejar_cliente(ClientSocket) :-
    tcp_read_socket(ClientSocket, _Request),
    imagenes(Imgs),
    random_between(1, 5, Idx),
    nth1(Idx, Imgs, Imagen),
    atomic_list_concat([
        'HTTP/1.1 200 OK\r\n',
        'Content-Type: application/json\r\n\r\n',
        '{"imagen_url":"', Imagen, '","estado":"ok"}'
    ], Respuesta),
    tcp_send(ClientSocket, Respuesta),
    tcp_close_socket(ClientSocket).
