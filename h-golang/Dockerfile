FROM golang:1.17 as builder

WORKDIR /app
COPY . .

RUN go build -v -o server

FROM gcr.io/distroless/base-debian10

WORKDIR /app
COPY --from=builder /app/server /app

CMD ["/app/server"]
