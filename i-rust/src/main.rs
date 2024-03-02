use actix_web::{web, App, HttpServer, HttpResponse, Responder};
use reqwest;

async fn say_hello() -> impl Responder {
    "Hello from Rust microservice!"
}

async fn handshake(text: String) -> impl Responder {
    println!("Input from client: {}", text);
    let client = reqwest::Client::new();
    let request_body = format!("{} Hello from Rust microservice!", text);
    let url = "http://host.docker.internal:8089/handshake";

    match client.post(url).body(request_body).send().await {
        Ok(response) => {
            if let Ok(text) = response.text().await {
                println!("Output to client: {}", text);
                HttpResponse::Ok().body(text)
            } else {
                HttpResponse::InternalServerError().body("Error in response text")
            }
        }
        Err(_) => HttpResponse::InternalServerError().body("Error in sending request"),
    }
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    HttpServer::new(|| {
        App::new()
            .route("/hello", web::get().to(say_hello))
            .route("/handshake", web::post().to(handshake))
    })
    .bind("0.0.0.0:8088")?
    .run()
    .await
}
