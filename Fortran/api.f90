program api_server
    use iso_c_binding
    implicit none

    integer(c_int) :: server_socket, client_socket
    integer(c_int) :: opt = 1
    integer(c_int), parameter :: PORT = 8097
    type(c_ptr) :: sockaddr_ptr
    character(len=*), parameter :: imagenes(5) = [ &
        "https://picsum.photos/800/600?random=1700", &
        "https://picsum.photos/800/600?random=1701", &
        "https://picsum.photos/800/600?random=1702", &
        "https://picsum.photos/800/600?random=1703", &
        "https://picsum.photos/800/600?random=1704" ]
    character(len=256) :: buffer, respuesta
    integer :: idx, seed_size
    integer, allocatable :: seed(:)

    call random_seed(size=seed_size)
    allocate(seed(seed_size))
    seed = 42
    call random_seed(put=seed)

    ! Crear socket, bind, listen (pseudocódigo con llamadas C)
    print *, "API en Fortran escuchando en http://localhost:", PORT

    do
        ! Aceptar conexión y responder
        call random_number(r)
        idx = int(r * 5) + 1
        write(respuesta, '("HTTP/1.1 200 OK", a, "Content-Type: application/json", a, a, &
            "{\""imagen_url\"":\"""", a, "\"",\""estado\"":\""ok\""}")') &
            char(13)//char(10), char(13)//char(10)//char(13)//char(10), trim(imagenes(idx))
        print *, trim(respuesta)
        exit ! Simplificado - en realidad sería un loop infinito
    end do
end program api_server
