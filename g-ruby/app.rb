require 'sinatra'
require 'net/http'

set :bind, '0.0.0.0'
set :port, 8086

get '/hello' do
  "Hello from Ruby microservice!"
end

post '/handshake' do
  input = request.body.read
  puts "Input from client: #{input}"
  request_body = "#{input} Hello from Ruby microservice!"
  url = URI("http://host.docker.internal:8087/handshake")
  response = Net::HTTP.post(url, request_body, "Content-Type" => "text/plain")
  output = response.body || "Error"
  puts "Output to client: #{output}"
  output
end
