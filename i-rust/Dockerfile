FROM rust:1.75-slim as builder
WORKDIR /usr/src/app

RUN apt-get update && apt-get install -y pkg-config libssl-dev

COPY . .
RUN cargo install --path .
EXPOSE 8088
CMD ["i-rust"]
