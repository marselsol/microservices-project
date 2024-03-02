package com.example

import org.springframework.boot.SpringApplication
import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.context.annotation.Bean
import org.springframework.web.client.RestTemplate

@SpringBootApplication
class MainApplication {
  @Bean
  def restTemplate(): RestTemplate = new RestTemplate()
}

object MainApplication extends App {
  SpringApplication.run(classOf[MainApplication], args: _*)
}
