       IDENTIFICATION DIVISION.
       PROGRAM-ID. API-SERVER.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 SERVER-SOCKET PIC 9(4) COMP.
       01 CLIENT-SOCKET PIC 9(4) COMP.
       01 SERVER-ADDR.
          05 FAMILY PIC 9(4) COMP VALUE 2.
          05 PORT PIC 9(4) COMP VALUE 8096.
          05 IP-ADDR PIC 9(8) COMP VALUE 0.
          05 PADDING PIC X(8) VALUE SPACES.
       01 CLIENT-ADDR.
          05 FAMILY PIC 9(4) COMP.
          05 PORT PIC 9(4) COMP.
          05 IP-ADDR PIC 9(8) COMP.
          05 PADDING PIC X(8).
       01 IMAGENES.
          05 PIC X(44) VALUE "https://picsum.photos/800/600?random=1600".
          05 PIC X(44) VALUE "https://picsum.photos/800/600?random=1601".
          05 PIC X(44) VALUE "https://picsum.photos/800/600?random=1602".
          05 PIC X(44) VALUE "https://picsum.photos/800/600?random=1603".
          05 PIC X(44) VALUE "https://picsum.photos/800/600?random=1604".
       01 IMAGEN-TABLE REDEFINES IMAGENES.
          05 IMAGEN-ITEM OCCURS 5 TIMES PIC X(44).
       01 WS-RANDOM PIC 9(1) COMP.
       01 WS-BUFFER PIC X(4096).
       01 WS-JSON PIC X(200).
       01 WS-RESPONSE PIC X(4096).
       01 WS-ADDRLEN PIC 9(4) COMP VALUE 16.
       PROCEDURE DIVISION.
       MAIN.
           CALL "C$SOCKET" USING SERVER-SOCKET, 2, 1, 0
           CALL "C$BIND" USING SERVER-SOCKET, SERVER-ADDR, 16
           CALL "C$LISTEN" USING SERVER-SOCKET, 3
           DISPLAY "API en COBOL escuchando en http://localhost:8096"

           PERFORM UNTIL 1 = 0
               CALL "C$ACCEPT" USING SERVER-SOCKET, CLIENT-SOCKET,
                   CLIENT-ADDR, WS-ADDRLEN
               CALL "C$RECV" USING CLIENT-SOCKET, WS-BUFFER, 4096, 0
               COMPUTE WS-RANDOM = FUNCTION RANDOM * 5 + 1
               STRING "HTTP/1.1 200 OK" X"0D0A"
                      "Content-Type: application/json" X"0D0A0D0A"
                      '{"imagen_url":"' IMAGEN-ITEM(WS-RANDOM) '","estado":"ok"}'
                      INTO WS-RESPONSE
               CALL "C$SEND" USING CLIENT-SOCKET, WS-RESPONSE,
                   FUNCTION LENGTH(WS-RESPONSE), 0
               CALL "C$CLOSE" USING CLIENT-SOCKET
           END-PERFORM
           STOP RUN.
