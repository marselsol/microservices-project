from app import app
import requests
from flask import request

@app.route('/hello', methods=['GET'])
def say_hello():
    return "Hello from Python microservice!"

@app.route('/handshake', methods=['POST'])
def handshake():
    text = request.data.decode('utf-8')
    request_content = text + " Hello from Python microservice!"
    url = "http://host.docker.internal:8082/handshake"
    response = requests.post(url, data=request_content)
    return response.text
