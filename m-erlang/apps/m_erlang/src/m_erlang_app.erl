-module(m_erlang_app).
-behaviour(application).

-export([start/0, stop/1]).
-export([start/2]).

start() ->
    io:format("Application: Starting m_erlang application~n"),

    Port = 8092,
    Dispatch = cowboy_router:compile([
                  {'_', [
                      {"/hello", m_erlang_hello_handler, []},
                      {"/handshake", m_erlang_handshake_handler, []}
                  ]}
              ]),
    {ok, _} = cowboy:start_clear(my_http_listener,
                                 [{port, Port}],
                                 #{env => #{dispatch => Dispatch}}),

    io:format("Supervisor: HTTP server is running on port ~p~n", [Port]),
    case m_erlang_sup:start_link() of
        {ok, _Pid} -> 
            ok;
        {error, Reason} ->
            io:format("Application: Failed to start m_erlang_sup: ~p~n", [Reason]),
            {error, Reason}
    end.

start(_StartType, _StartArgs) ->
    io:format("Application: Starting m_erlang application~n"),

    Port = 8092,
    Dispatch = cowboy_router:compile([
                  {'_', [
                      {"/hello", m_erlang_hello_handler, []},
                      {"/handshake", m_erlang_handshake_handler, []}
                  ]}
              ]),
    {ok, _} = cowboy:start_clear(my_http_listener,
                                 [{port, Port}],
                                 #{env => #{dispatch => Dispatch}}),

    io:format("Application: HTTP server is running on port ~p~n", [Port]),
    case m_erlang_sup:start_link() of
        {ok, _Pid} = Ok ->
            Ok;
        {error, Reason} ->
            io:format("Application: Failed to start m_erlang_sup: ~p~n", [Reason]),
            {error, Reason}
    end.

stop(_State) ->
    io:format("Application: Stopping m_erlang application~n"),
    ok.
