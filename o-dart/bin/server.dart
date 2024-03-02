import 'dart:io';
import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:http/http.dart' as http;

void main(List<String> args) {
  var handler = const Pipeline().addMiddleware(logRequests()).addHandler(_echoRequest);
  serve(handler, InternetAddress.anyIPv4, 8094);
  print('Serving at http://0.0.0.0:8094');
}

Future<Response> _echoRequest(Request request) async {
  if (request.method == 'POST' && request.url.path == 'handshake') {
    String content = await request.readAsString();
    print("Input from client: $content");
    String requestText = "$content Hello from Dart microservice!";
    var response = await sendToExternalService(requestText);
    return Response.ok(response);
  } else if (request.method == 'GET' && request.url.path == 'hello') {
    return Response.ok('Hello from Dart microservice!');
  }
  return Response.notFound('Not Found');
}

Future<String> sendToExternalService(String message) async {
  try {
    var url = 'http://host.docker.internal:8095/handshake';
    var response = await http.post(Uri.parse(url), body: message);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return 'Error: ${response.reasonPhrase}';
    }
  } catch (e) {
    return 'Error sending request: $e';
  }
}
