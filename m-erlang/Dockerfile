FROM erlang:23-slim
WORKDIR /app
COPY . .
RUN rebar3 compile
RUN rebar3 as m_erlang release
EXPOSE 8092
CMD ["_build/m_erlang/rel/m_erlang/bin/m_erlang", "foreground"]