import 'dart:io';
import 'dart:convert';
import 'dart:math';

void main() async {
  var server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8092);
  print('API en Dart escuchando en http://localhost:8092');

  var imagenes = [
    "https://picsum.photos/800/600?random=1200",
    "https://picsum.photos/800/600?random=1201",
    "https://picsum.photos/800/600?random=1202",
    "https://picsum.photos/800/600?random=1203",
    "https://picsum.photos/800/600?random=1204"
  ];

  var rng = Random();

  await for (var request in server) {
    var imagen = imagenes[rng.nextInt(imagenes.length)];
    var json = jsonEncode({"imagen_url": imagen, "estado": "ok"});
    request.response
      ..headers.contentType = ContentType.json
      ..write(json)
      ..close();
  }
}
