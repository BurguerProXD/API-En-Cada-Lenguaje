-module(api).
-export([start/0]).

start() ->
    {ok, ListenSocket} = gen_tcp:listen(8099, [{active, false}, {reuseaddr, true}]),
    io:format("API en Erlang escuchando en http://localhost:8099~n"),
    accept_loop(ListenSocket).

accept_loop(ListenSocket) ->
    {ok, Socket} = gen_tcp:accept(ListenSocket),
    spawn(fun() -> handle_request(Socket) end),
    accept_loop(ListenSocket).

handle_request(Socket) ->
    gen_tcp:recv(Socket, 0),
    Imagenes = [
        "https://picsum.photos/800/600?random=1900",
        "https://picsum.photos/800/600?random=1901",
        "https://picsum.photos/800/600?random=1902",
        "https://picsum.photos/800/600?random=1903",
        "https://picsum.photos/800/600?random=1904"
    ],
    <<A:32, B:32, C:32>> = os:timestamp(),
    random:seed(A, B, C),
    Idx = random:uniform(5),
    Imagen = lists:nth(Idx, Imagenes),
    Json = "{\"imagen_url\":\"" ++ Imagen ++ "\",\"estado\":\"ok\"}",
    Response = "HTTP/1.1 200 OK\r\nContent-Type: application/json\r\n\r\n" ++ Json,
    gen_tcp:send(Socket, Response),
    gen_tcp:close(Socket).
