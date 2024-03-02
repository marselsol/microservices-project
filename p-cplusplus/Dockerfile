FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y tzdata g++ cmake git libcpprest-dev

COPY . /usr/src/myapp
WORKDIR /usr/src/myapp
RUN cmake . && make
EXPOSE 8095
CMD ["./cplusplus-microservice"]
