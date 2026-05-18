import com.sun.net.httpserver.HttpServer
import java.net.InetSocketAddress
import java.util.Random

val IMAGENES = arrayOf(
    "https://picsum.photos/800/600?random=1100",
    "https://picsum.photos/800/600?random=1101",
    "https://picsum.photos/800/600?random=1102",
    "https://picsum.photos/800/600?random=1103",
    "https://picsum.photos/800/600?random=1104"
)

fun main() {
    val server = HttpServer.create(InetSocketAddress(8091), 0)
    server.createContext("/") { exchange ->
        val imagen = IMAGENES[Random().nextInt(IMAGENES.size)]
        val json = "{\"imagen_url\":\"$imagen\",\"estado\":\"ok\"}"
        exchange.responseHeaders.set("Content-Type", "application/json")
        exchange.sendResponseHeaders(200, json.length.toLong())
        val os = exchange.responseBody
        os.write(json.toByteArray())
        os.close()
    }
    server.start()
    println("API en Kotlin escuchando en http://localhost:8091")
}
