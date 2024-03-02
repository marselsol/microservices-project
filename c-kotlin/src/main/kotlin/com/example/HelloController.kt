package com.example

import org.springframework.web.bind.annotation.*
import org.springframework.web.client.RestTemplate

@RestController
class HelloController(private val restTemplate: RestTemplate) {

    @GetMapping("/hello")
    fun sayHello(): String = "Hello from Kotlin microservice!"

    @PostMapping("/handshake")
    fun handshake(@RequestBody text: String): String {
        println("Input from client: $text")

        val request = "$text Hello from Kotlin microservice!"
        val url = "http://host.docker.internal:8083/handshake"
        
        val response = restTemplate.postForObject(url, request, String::class.java) ?: "Error"
        
        println("Output to client: $response")

        return response
    }
}
