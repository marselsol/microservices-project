FROM debian:buster
RUN apt-get update && apt-get install -y libmicrohttpd-dev gcc make curl libcurl4-openssl-dev
WORKDIR /r-c
COPY src /r-c/src
COPY Makefile /r-c/
RUN make
EXPOSE 8097
CMD ["./main"]