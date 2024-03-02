import Vapor

let app = Application()
defer { app.shutdown() }

app.http.server.configuration.hostname = "0.0.0.0"
app.http.server.configuration.port = 8093

app.routes.get("hello") { req -> String in
    "Hello from Swift microservice!"
}

app.routes.post("handshake") { req -> EventLoopFuture<String> in
    guard let buffer = req.body.string else {
        return req.eventLoop.future(error: Abort(.unsupportedMediaType))
    }
    print("Input from client: \(buffer)")
    let request = "\(buffer) Hello from Swift microservice!"
    let url = URI(string: "http://host.docker.internal:8094/handshake")
    
    return req.client.post(url, beforeSend: { req in
        req.headers.add(name: "Content-Type", value: "text/plain")
        try req.content.encode(request, as: .plainText)
    }).map { res in
        guard let body = res.body else { return "Errorrrrrrrrr" }
        return body.getString(at: 0, length: body.readableBytes) ?? "Errorrrrrr"
    }
}

try app.run()
