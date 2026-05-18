-- Usa LuaSocket que viene en muchas distribuciones como módulo nativo
local socket = require("socket")
local json = require("json") -- json.lua puro (incluido como string)

local PORT = 8093
local IMAGENES = {
    "https://picsum.photos/800/600?random=1300",
    "https://picsum.photos/800/600?random=1301",
    "https://picsum.photos/800/600?random=1302",
    "https://picsum.photos/800/600?random=1303",
    "https://picsum.photos/800/600?random=1304"
}

math.randomseed(os.time())

local server = socket.tcp()
server:bind("127.0.0.1", PORT)
server:listen(5)
print("API en Lua escuchando en http://localhost:" .. PORT)

while true do
    local client = server:accept()
    client:receive("*l")
    local idx = math.random(#IMAGENES)
    local json_resp = '{"imagen_url":"' .. IMAGENES[idx] .. '","estado":"ok"}'
    local response = "HTTP/1.1 200 OK\r\nContent-Type: application/json\r\n\r\n" .. json_resp
    client:send(response)
    client:close()
end
