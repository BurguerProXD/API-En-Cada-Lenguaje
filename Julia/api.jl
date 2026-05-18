using Sockets
using JSON
using Random

const PORT = 8105
const IMAGENES = [
    "https://picsum.photos/800/600?random=2500",
    "https://picsum.photos/800/600?random=2501",
    "https://picsum.photos/800/600?random=2502",
    "https://picsum.photos/800/600?random=2503",
    "https://picsum.photos/800/600?random=2504"
]

function start_server()
    server = listen(IPv4(127,0,0,1), PORT)
    println("API en Julia escuchando en http://localhost:$PORT")
    
    while true
        client = accept(server)
        @async begin
            try
                readline(client)  # Leer request
                imagen = rand(IMAGENES)
                json_resp = JSON.json(Dict("imagen_url" => imagen, "estado" => "ok"))
                response = "HTTP/1.1 200 OK\r\nContent-Type: application/json\r\n\r\n$json_resp"
                write(client, response)
                close(client)
            catch e
                println("Error: $e")
            end
        end
    end
end

start_server()
