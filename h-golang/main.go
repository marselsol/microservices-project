package main

import (
	"bytes"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
)

func main() {
	http.HandleFunc("/hello", sayHello)
	http.HandleFunc("/handshake", handleHandshake)

	log.Fatal(http.ListenAndServe(":8087", nil))
}

func sayHello(w http.ResponseWriter, r *http.Request) {
	_, _ = fmt.Fprintf(w, "Hello from Golang microservice!")
}

func handleHandshake(w http.ResponseWriter, r *http.Request) {
	body, err := ioutil.ReadAll(r.Body)
	if err != nil {
		http.Error(w, "Error reading request body", http.StatusInternalServerError)
		return
	}
	inputText := string(body)
	fmt.Println("Input from client:", inputText)

	requestText := inputText + " Hello from Golang microservice!"
	url := "http://host.docker.internal:8088/handshake"
	responseBody, err := sendPostRequest(url, requestText)
	if err != nil {
		http.Error(w, "Error sending post request", http.StatusInternalServerError)
		return
	}
	fmt.Println("Output to client:", responseBody)
	_, _ = fmt.Fprint(w, responseBody)
}

func sendPostRequest(url, bodyText string) (string, error) {
	body := bytes.NewBufferString(bodyText)
	resp, err := http.Post(url, "text/plain", body)
	if err != nil {
		return "", err
	}
	defer resp.Body.Close()

	responseBody, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return "", err
	}
	return string(responseBody), nil
}
