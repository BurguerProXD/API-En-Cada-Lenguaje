with Ada.Text_IO; use Ada.Text_IO;
with GNAT.Sockets; use GNAT.Sockets;
with Ada.Numerics.Discrete_Random;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

procedure Api is
   PORT : constant Port_Type := 8095;
   IMAGENES : constant array(1..5) of Unbounded_String := (
       To_Unbounded_String("https://picsum.photos/800/600?random=1500"),
       To_Unbounded_String("https://picsum.photos/800/600?random=1501"),
       To_Unbounded_String("https://picsum.photos/800/600?random=1502"),
       To_Unbounded_String("https://picsum.photos/800/600?random=1503"),
       To_Unbounded_String("https://picsum.photos/800/600?random=1504")
   );

   subtype Index_Range is Integer range 1..5;
   package Random_Index is new Ada.Numerics.Discrete_Random(Index_Range);
   Gen : Random_Index.Generator;

   Server_Socket, Client_Socket : Socket_Type;
   Server_Addr, Client_Addr : Sock_Addr_Type;
   Channel : Stream_Access;
   Idx : Index_Range;
begin
   Random_Index.Reset(Gen);
   Create_Socket(Server_Socket);
   Server_Addr.Addr := Inet_Addr("127.0.0.1");
   Server_Addr.Port := PORT;
   Bind_Socket(Server_Socket, Server_Addr);
   Listen_Socket(Server_Socket);
   Put_Line("API en Ada escuchando en http://localhost:" & Port_Type'Image(PORT));

   loop
      Accept_Socket(Server_Socket, Client_Socket, Client_Addr);
      Channel := Stream(Client_Socket);
      Idx := Random_Index.Random(Gen);
      String'Write(Channel,
         "HTTP/1.1 200 OK" & CRLF &
         "Content-Type: application/json" & CRLF & CRLF &
         "{\"imagen_url\":\"" & To_String(IMAGENES(Idx)) & "\",\"estado\":\"ok\"}");
      Close_Socket(Client_Socket);
   end loop;
end Api;
