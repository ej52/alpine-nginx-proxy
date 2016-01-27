FROM ej52/alpine-nginx
MAINTAINER Elton Renda "https://github.com/ej52"

# Configure Nginx and apply fix for very long server names
RUN sed -i 's/^http {/&\n    server_names_hash_bucket_size 128;/g' /etc/nginx/nginx.conf

COPY forego /usr/local/bin/

# forego fails w/ /bin/sh. install /bin/bash
RUN apk --update add bash

ENV DOCKER_GEN_VERSION 0.5.0

RUN wget -O- \
 https://github.com/jwilder/docker-gen/releases/download/$DOCKER_GEN_VERSION/docker-gen-alpine-linux-amd64-$DOCKER_GEN_VERSION.tar.gz | \
 tar -C /usr/local/bin -xvzf - && chown root:root /usr/local/bin/docker-gen

WORKDIR /app/
ADD app /app/

ENV DOCKER_HOST unix:///tmp/docker.sock

VOLUME ["/etc/nginx/certs"]

ENTRYPOINT ["/app/docker-entrypoint.sh"]
CMD ["forego", "start", "-r"]
