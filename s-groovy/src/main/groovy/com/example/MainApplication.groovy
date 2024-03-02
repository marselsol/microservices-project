package com.example

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.builder.SpringApplicationBuilder
import org.springframework.context.annotation.Bean
import org.springframework.web.client.RestTemplate

@SpringBootApplication
class MainApplication {

    static void main(String[] args) {
        new SpringApplicationBuilder(MainApplication.class).run(args)
    }

    @Bean
    RestTemplate restTemplate() {
        new RestTemplate()
    }
}
