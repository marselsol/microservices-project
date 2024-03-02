package com.example

import org.springframework.web.bind.annotation._
import org.springframework.web.client.RestTemplate
import org.springframework.beans.factory.annotation.Autowired

@RestController
class HelloController @Autowired()(private val restTemplate: RestTemplate) {

  @GetMapping(Array("/hello"))
  def sayHello(): String = "Hello from Scala microservice!"

  @PostMapping(Array("/handshake"))
  def handshake(@RequestBody text: String): String = {
    println(s"Input from client: $text")
    val request = s"$text Hello from Scala microservice!"
    val url = "http://host.docker.internal:8090/handshake"
    val response = Option(restTemplate.postForObject(url, request, classOf[String])).getOrElse("Error")
    println(s"Output to client: $response")
    response
  }
}
