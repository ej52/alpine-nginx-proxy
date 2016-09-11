FROM ej52/alpine-nginx:latest
MAINTAINER Elton Renda "https://github.com/ej52"

# Configure Nginx and apply fix for very long server names
RUN sed -i 's/^http {/&\n    server_names_hash_bucket_size 128;/g' /etc/nginx/nginx.conf

# forego fails w/ /bin/sh. install /bin/bash
RUN apk --no-cache add bash

ENV DOCKER_GEN_VERSION 0.7.3

RUN wget -O- \
 https://github.com/jwilder/docker-gen/releases/download/$DOCKER_GEN_VERSION/docker-gen-alpine-linux-amd64-$DOCKER_GEN_VERSION.tar.gz | \
 tar -C /usr/local/bin -xvzf - && chown root:root /usr/local/bin/docker-gen

ADD root /app/
WORKDIR /app/

ENV DOCKER_HOST unix:///tmp/docker.sock

VOLUME ["/etc/nginx/certs"]
