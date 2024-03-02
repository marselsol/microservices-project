<?php
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\Factory\AppFactory;

require __DIR__ . '/vendor/autoload.php';

$app = AppFactory::create();

$app->get('/hello', function (Request $request, Response $response, $args) {
    $response->getBody()->write("Hello from PHP microservice!");
    return $response;
});

$app->post('/handshake', function (Request $request, Response $response, $args) {
    $input = $request->getBody()->getContents();
    error_log("Input from client: " . $input);

    $textToSend = $input . " Hello from PHP microservice!";
    $url = "http://host.docker.internal:8086/handshake";

    $client = new GuzzleHttp\Client();
    $res = $client->request('POST', $url, [
        'body' => $textToSend,
        'headers' => [
            'Content-Type' => 'text/plain'
        ]
    ]);

    $responseBody = $res->getBody()->getContents(); 
    error_log("Output from service: " . $responseBody);

    $response->getBody()->write($responseBody);
    return $response;
});

$app->run();