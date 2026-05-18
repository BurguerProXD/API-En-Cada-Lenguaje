#!/bin/bash

PORT=8103
IMAGENES=(
    "https://picsum.photos/800/600?random=2300"
    "https://picsum.photos/800/600?random=2301"
    "https://picsum.photos/800/600?random=2302"
    "https://picsum.photos/800/600?random=2303"
    "https://picsum.photos/800/600?random=2304"
)

echo "API en Bash escuchando en http://localhost:$PORT"

while true; do
    nc -l -p $PORT -q 1 | while read request; do
        if [[ $request == GET* ]] || [[ -z $request ]]; then
            idx=$((RANDOM % 5))
            imagen="${IMAGENES[$idx]}"
            cat <<EOF
HTTP/1.1 200 OK
Content-Type: application/json

{"imagen_url":"$imagen","estado":"ok"}
EOF
            break
        fi
    done
done
