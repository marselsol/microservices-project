const express = require('express');
const axios = require('axios');
require('dotenv').config();

const app = express();
app.use(express.text());

app.get('/hello', (req, res) => {
    res.send("Hello from JavaScript microservice!");
});

app.post('/handshake', async (req, res) => {
    const incomingText = req.body;
    const requestContent = `${incomingText} Hello from JavaScript microservice!`;
    const url = "http://host.docker.internal:8084/handshake";

    try {
        const response = await axios.post(url, requestContent, {
            headers: { 'Content-Type': 'text/plain' }
        });
        res.send(response.data);
    } catch (error) {
        res.send("Error");
    }
});

const PORT = process.env.PORT || 8083;
app.listen(PORT);
