require 'webrick'
require 'json'

PORT = 8089
IMAGENES = [
    "https://picsum.photos/800/600?random=900",
    "https://picsum.photos/800/600?random=901",
    "https://picsum.photos/800/600?random=902",
    "https://picsum.photos/800/600?random=903",
    "https://picsum.photos/800/600?random=904"
]

server = WEBrick::HTTPServer.new(Port: PORT)

server.mount_proc '/' do |req, res|
    res.content_type = 'application/json'
    res.body = {
        imagen_url: IMAGENES.sample,
        estado: "ok"
    }.to_json
end

trap('INT') { server.shutdown }
puts "API en Ruby escuchando en http://localhost:#{PORT}"
server.start
