FROM swift:5.3


RUN apt-get update && apt-get install -y git

WORKDIR /app
COPY . .


RUN git config --global http.postBuffer 524288000
RUN git config --global http.lowSpeedLimit 0
RUN git config --global http.lowSpeedTime 999999


RUN echo '#!/bin/sh\n\
n=0\n\
until [ "$n" -ge 5 ]\n\
do\n\
   swift build -c release && break\n\
   n=$((n+1))\n\
   echo "Attempt $n failed... will try again in 5 seconds"\n\
   sleep 5\n\
done' > retry_build.sh && chmod +x retry_build.sh


RUN ./retry_build.sh

EXPOSE 8093
CMD [".build/release/App"]