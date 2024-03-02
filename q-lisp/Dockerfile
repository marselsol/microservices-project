FROM 40ants/base-lisp-image:latest-sbcl-bin
WORKDIR /app
COPY .  /app

RUN CL_SOURCE_REGISTRY=`pwd`/ ros run --load build.lisp

EXPOSE 8096

ENTRYPOINT ["/app/app"]
