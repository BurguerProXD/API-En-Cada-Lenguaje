import Network.Socket
import System.IO
import System.Random
import Data.List (intercalate)
import Control.Monad (forever)

port :: Int
port = 8098

imagenes :: [String]
imagenes = [
    "https://picsum.photos/800/600?random=1800",
    "https://picsum.photos/800/600?random=1801",
    "https://picsum.photos/800/600?random=1802",
    "https://picsum.photos/800/600?random=1803",
    "https://picsum.photos/800/600?random=1804"
]

main :: IO ()
main = do
    sock <- socket AF_INET Stream defaultProtocol
    setSocketOption sock ReuseAddr 1
    bind sock (SockAddrInet (fromIntegral port) 0x0100007f)
    listen sock 3
    putStrLn $ "API en Haskell escuchando en http://localhost:" ++ show port

    forever $ do
        (clientSock, _) <- accept sock
        handle <- socketToHandle clientSock ReadWriteMode
        hSetBuffering handle NoBuffering
        idx <- randomRIO (0, 4)
        let imagen = imagenes !! idx
        let json = "{\"imagen_url\":\"" ++ imagen ++ "\",\"estado\":\"ok\"}"
        hPutStr handle $ "HTTP/1.1 200 OK\r\nContent-Type: application/json\r\n\r\n" ++ json
        hClose handle
