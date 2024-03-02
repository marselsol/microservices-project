require "http/client"

get "/hello" do |env|
  "Hello from Crystal microservice!"
end

post "/handshake" do |env|
  body = env.request.body.not_nil!.gets_to_end
  puts "Input from client: #{body}"
  request_text = "#{body} Hello from Crystal microservice!"

  response = HTTP::Client.post("http://host.docker.internal:8888/handshake", body: request_text)
  output = response.body.presence || "Error"
  puts "Output to client: #{output}"

  output
end
