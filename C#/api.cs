using System;
using System.Net;
using System.Text;
using System.Threading;

class ApiServer
{
    static string[] imagenes = {
        "https://picsum.photos/800/600?random=100",
        "https://picsum.photos/800/600?random=101",
        "https://picsum.photos/800/600?random=102",
        "https://picsum.photos/800/600?random=103",
        "https://picsum.photos/800/600?random=104"
    };

    static void Main()
    {
        HttpListener listener = new HttpListener();
        listener.Prefixes.Add("http://localhost:8082/");
        listener.Start();
        Console.WriteLine("API en C# escuchando en http://localhost:8082");

        Random rand = new Random();

        while (true)
        {
            HttpListenerContext context = listener.GetContext();
            HttpListenerResponse response = context.Response;

            string imagenUrl = imagenes[rand.Next(imagenes.Length)];
            string json = "{\"imagen_url\":\"" + imagenUrl + "\",\"estado\":\"ok\"}";
            byte[] buffer = Encoding.UTF8.GetBytes(json);

            response.ContentType = "application/json";
            response.ContentLength64 = buffer.Length;
            response.OutputStream.Write(buffer, 0, buffer.Length);
            response.OutputStream.Close();
        }
    }
}
