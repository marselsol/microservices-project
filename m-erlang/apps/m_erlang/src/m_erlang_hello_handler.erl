-module(m_erlang_hello_handler).

-export([
         init/2
        ]).

init(Req0, Opts) ->
    io:format("Hello handler received a request~n"),
    Req = cowboy_req:reply(200, #{<<"content-type">> => <<"text/plain">>}, <<"Hello from Erlang microservice!">>, Req0),
    {ok, Req, Opts}.