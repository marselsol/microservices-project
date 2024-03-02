#include <cpprest/http_listener.h>
#include <cpprest/http_client.h>
#include <cpprest/json.h>
#include <iostream>

using namespace web;
using namespace web::http;
using namespace web::http::client;
using namespace web::http::experimental::listener;

void handle_post(http_request request) {
    request.extract_string().then([=](std::string text) {
        try {
            std::cout << "Input from client: " << text << std::endl;
            auto response_text = text + " Hello from C++ microservice!";
            http_client client(U("http://host.docker.internal:8096/handshake"));

            client.request(methods::POST, U("/"), response_text, U("text/plain")).then([=](http_response response) {
                if (response.status_code() == status_codes::OK) {
                    return response.extract_string();
                } else {
                    return pplx::task_from_result<std::string>("Error");
                }
            }).then([=](pplx::task<std::string> prevTask) {
                try {
                    auto response = prevTask.get();
                    std::cout << "Output to client: " << response << std::endl;
                    request.reply(status_codes::OK, response);
                } catch (const std::exception &e) {
                    std::cerr << "Error occurred: " << e.what() << std::endl;
                    request.reply(status_codes::InternalError, "Internal Server Error");
                }
            });
        } catch (const std::exception &e) {
            std::cerr << "Error occurred: " << e.what() << std::endl;
            request.reply(status_codes::InternalError, "Internal Server Error");
        }
    });
}

void handle_get(http_request request) {
    request.reply(status_codes::OK, "Hello from C++ microservice!");
}

int main() {
    http_listener listener("http://0.0.0.0:8095");

    listener.support(methods::GET, handle_get);
    listener.support(methods::POST, handle_post);

    try {
        listener
            .open()
            .then([&listener]() { std::cout << "Starting server...\n"; })
            .wait();

        while (true);
    }
    catch (std::exception const &e) {
        std::cout << e.what() << std::endl;
    }

    return 0;
}
