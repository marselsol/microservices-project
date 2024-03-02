-module(m_erlang_sup).
-behaviour(supervisor).

-export([start_link/0, init/1]).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
    io:format("Supervisor: Starting up~n"),
    {ok, {{one_for_one, 5, 10}, []}}.
