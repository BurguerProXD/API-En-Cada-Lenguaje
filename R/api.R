# API en R usando el paquete httpuv (incluido en instalaciones modernas de R)

library(httpuv)

PORT <- 8104
IMAGENES <- c(
    "https://picsum.photos/800/600?random=2400",
    "https://picsum.photos/800/600?random=2401",
    "https://picsum.photos/800/600?random=2402",
    "https://picsum.photos/800/600?random=2403",
    "https://picsum.photos/800/600?random=2404"
)

app <- list(
    call = function(req) {
        imagen <- sample(IMAGENES, 1)
        body <- sprintf('{"imagen_url":"%s","estado":"ok"}', imagen)
        list(
            status = 200L,
            headers = list('Content-Type' = 'application/json'),
            body = body
        )
    }
)

cat(sprintf("API en R escuchando en http://localhost:%d\n", PORT))
runServer("0.0.0.0", PORT, app)
