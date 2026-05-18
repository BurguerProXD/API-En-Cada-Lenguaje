program api;

uses
    sockets, sysutils, crt;

const
    PORT = 8094;
    IMAGENES: array[1..5] of string = (
        'https://picsum.photos/800/600?random=1400',
        'https://picsum.photos/800/600?random=1401',
        'https://picsum.photos/800/600?random=1402',
        'https://picsum.photos/800/600?random=1403',
        'https://picsum.photos/800/600?random=1404'
    );

var
    ServerSocket, ClientSocket: LongInt;
    ServerAddr, ClientAddr: TInetSockAddr;
    ClientAddrLen: LongInt;
    buffer: string[4096];
    idx: Integer;
    json: string;

begin
    Randomize;
    ServerSocket := fpSocket(AF_INET, SOCK_STREAM, 0);
    
    ServerAddr.sin_family := AF_INET;
    ServerAddr.sin_port := htons(PORT);
    ServerAddr.sin_addr.s_addr := INADDR_ANY;
    
    fpBind(ServerSocket, @ServerAddr, SizeOf(ServerAddr));
    fpListen(ServerSocket, 3);
    
    writeln('API en Pascal escuchando en http://localhost:', PORT);
    
    while True do
    begin
        ClientAddrLen := SizeOf(ClientAddr);
        ClientSocket := fpAccept(ServerSocket, @ClientAddr, @ClientAddrLen);
        
        fpRecv(ClientSocket, @buffer, SizeOf(buffer), 0);
        
        idx := Random(5) + 1;
        json := '{"imagen_url":"' + IMAGENES[idx] + '","estado":"ok"}';
        buffer := 'HTTP/1.1 200 OK'#13#10'Content-Type: application/json'#13#10#13#10 + json;
        
        fpSend(ClientSocket, @buffer[1], Length(buffer), 0);
        CloseSocket(ClientSocket);
    end;
    
    CloseSocket(ServerSocket);
end.
