; API en Assembly x86_64 Linux usando syscalls puras
; Compilar: nasm -f elf64 api.asm && ld api.o -o api

section .data
    port dw 0x1FA5          ; Puerto 8102 en network byte order
    images db "https://picsum.photos/800/600?random=2200",0
    response db "HTTP/1.1 200 OK",13,10,"Content-Type: application/json",13,10,13,10
    json_start db '{"imagen_url":"'
    json_end db '","estado":"ok"}'
    
section .bss
    server_sock resd 1
    client_sock resd 1
    sockaddr resb 16
    buffer resb 4096

section .text
    global _start

_start:
    ; socket(AF_INET, SOCK_STREAM, 0)
    mov rax, 41
    mov rdi, 2
    mov rsi, 1
    xor rdx, rdx
    syscall
    mov [server_sock], rax

    ; bind
    mov rax, 49
    mov rdi, [server_sock]
    mov rsi, sockaddr
    mov rdx, 16
    syscall

    ; listen
    mov rax, 50
    mov rdi, [server_sock]
    mov rsi, 3
    syscall

accept_loop:
    ; accept
    mov rax, 43
    mov rdi, [server_sock]
    xor rsi, rsi
    xor rdx, rdx
    syscall
    mov [client_sock], rax

    ; read request
    mov rax, 0
    mov rdi, [client_sock]
    mov rsi, buffer
    mov rdx, 4096
    syscall

    ; write response
    mov rax, 1
    mov rdi, [client_sock]
    mov rsi, response
    mov rdx, 78
    syscall

    ; close client
    mov rax, 3
    mov rdi, [client_sock]
    syscall

    jmp accept_loop
