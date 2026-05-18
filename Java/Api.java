import com.sun.net.httpserver.HttpServer;
import com.sun.net.httpserver.HttpHandler;
import com.sun.net.httpserver.HttpExchange;
import java.io.OutputStream;
import java.io.IOException;
import java.net.InetSocketAddress;
import java.util.Random;

public class Api {
    private static final String[] IMAGENES = {
        "https://picsum.photos/800/600?random=300",
        "https://picsum.photos/800/600?random=301",
        "https://picsum.photos/800/600?random=302",
        "https://picsum.photos/800/600?random=303",
        "https://picsum.photos/800/600?random=304"
    };

    public static void main(String[] args) throws IOException {
        HttpServer server = HttpServer.create(new InetSocketAddress(8084), 0);
        server.createContext("/", new ImageHandler());
        server.setExecutor(null);
        System.out.println("API en Java escuchando en http://localhost:8084");
        server.start();
    }

    static class ImageHandler implements HttpHandler {
        public void handle(HttpExchange exchange) throws IOException {
            Random rand = new Random();
            String imagen = IMAGENES[rand.nextInt(IMAGENES.length)];
            String json = "{\"imagen_url\":\"" + imagen + "\",\"estado\":\"ok\"}";

            exchange.getResponseHeaders().set("Content-Type", "application/json");
            exchange.sendResponseHeaders(200, json.length());
            OutputStream os = exchange.getResponseBody();
            os.write(json.getBytes());
            os.close();
        }
    }
}
