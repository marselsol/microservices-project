package com.example

import org.springframework.web.bind.annotation.*
import org.springframework.web.client.RestTemplate

@RestController
class HelloController {

    private final RestTemplate restTemplate

    HelloController(RestTemplate restTemplate) {
        this.restTemplate = restTemplate
    }

    @GetMapping("/hello")
    String sayHello() {
        "Hello from Groovy microservice!"
    }

    @PostMapping("/handshake")
    String handshake(@RequestBody String text) {
        println("Input from client: $text")
        String request = "$text Hello from Groovy microservice!"
        String url = "http://host.docker.internal:8099/handshake"
        String response = restTemplate.postForObject(url, request, String.class) ?: "Error"
        println("Output to client: $response")
        return response
    }
}
