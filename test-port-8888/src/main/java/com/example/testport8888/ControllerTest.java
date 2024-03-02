package com.example.testport8888;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class ControllerTest {
    @PostMapping("/handshake")
    public ResponseEntity<String> receiveAndRespond(@RequestBody String body) {
        System.out.println("input: " + body);
        String response = body + " Received FROM TESTPORT8888!";
        return ResponseEntity.ok(response);
    }
}