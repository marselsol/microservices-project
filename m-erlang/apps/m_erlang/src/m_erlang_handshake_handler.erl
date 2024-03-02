-module(m_erlang_handshake_handler).
%%-behaviour(cowboy_handler).
-export([init/2]).

init(Req0, Opts) ->
    io:format("Handshake handler received a request~n"),
    {ok, Body, Req} = cowboy_req:read_body(Req0),
    RequestText = <<Body/binary, " Hello from Erlang microservice!">>,
    
    io:format("Sending handshake to external service~n"),
    {ok, {{_, 200, _}, _, ResponseBody}} = httpc:request(post, {"http://host.docker.internal:8093/handshake", [{"Content-Type", "text/plain"}], "", RequestText}, [], []),
    io:format("Replying to request ~p~n", [ResponseBody]),
    {ok, Req2} = cowboy_req:reply(200, #{<<"content-type">> => <<"text/plain">>}, ResponseBody, Req),
    {ok, Req2, Opts}.