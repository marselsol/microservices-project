How to build
============

```
$ docker build -t http-app .
```

How to run
==========

```
$ docker network create test-net

$ docker run --rm -ti --name foo --network test-net -p 1090:80 http-app
```

then in other console:

```
$ docker run --rm -ti --name bar --network test-net -p 1091:80 http-app
```

After that, server foo will be able to call server bar's handshake:

```
$ curl -v -H 'x-handshake-url: http://bar/' -d 'Hi there!' 'http://localhost:1090/'
*   Trying 127.0.0.1:1090...
* Connected to localhost (127.0.0.1) port 1090 (#0)
> POST / HTTP/1.1
> Host: localhost:1090
> User-Agent: curl/7.81.0
> Accept: */*
> x-handshake-url: http://bar/
> Content-Length: 9
> Content-Type: application/x-www-form-urlencoded
>
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 OK
< Date: Thu, 04 Jan 2024 08:40:53 GMT
< Server: Hunchentoot 1.3.0
< Transfer-Encoding: chunked
< Content-Type: text/plain
<
* Connection #0 to host localhost left intact
Hi there! Hello from LISP microservice! Hello from LISP microservice!
```

The message `Hi there! Hello from LISP microservice! Hello from LISP microservice!`
was constructed by two services in our docker containers.
