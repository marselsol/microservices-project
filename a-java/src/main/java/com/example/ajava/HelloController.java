package com.example.ajava;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

@RestController
public class HelloController {
    private final RestTemplate restTemplate;

    public HelloController(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }

    @GetMapping("/hello")
    public String sayHello() {
        return "Hello from Java microservice!";
    }

    @GetMapping("/handshake/{text}")
    public String handshake(@PathVariable String text) {
        System.out.println("Input tex: " + text);
        String request = text + " Hello from Java microservice!";
        String url = "http://host.docker.internal:8081/handshake";
        return restTemplate.postForObject(url, request, String.class);
    }
}