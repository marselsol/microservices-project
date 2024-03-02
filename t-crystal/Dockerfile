FROM crystallang/crystal:1.2.2

WORKDIR /app

COPY . /app

RUN shards install

RUN crystal build src/main_application.cr --release

EXPOSE 8099

CMD ["./main_application"]
