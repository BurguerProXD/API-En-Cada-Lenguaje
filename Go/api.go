package main

import (
    "encoding/json"
    "fmt"
    "math/rand"
    "net/http"
    "time"
)

var imagenes = []string{
    "https://picsum.photos/800/600?random=600",
    "https://picsum.photos/800/600?random=601",
    "https://picsum.photos/800/600?random=602",
    "https://picsum.photos/800/600?random=603",
    "https://picsum.photos/800/600?random=604",
}

type Respuesta struct {
    ImagenURL string `json:"imagen_url"`
    Estado    string `json:"estado"`
}

func handler(w http.ResponseWriter, r *http.Request) {
    rand.Seed(time.Now().UnixNano())
    respuesta := Respuesta{
        ImagenURL: imagenes[rand.Intn(len(imagenes))],
        Estado:    "ok",
    }
    w.Header().Set("Content-Type", "application/json")
    json.NewEncoder(w).Encode(respuesta)
}

func main() {
    http.HandleFunc("/", handler)
    fmt.Println("API en Go escuchando en http://localhost:8087")
    http.ListenAndServe(":8087", nil)
}
