FROM ej52/alpine-nginx:latest
MAINTAINER Elton Renda "https://github.com/ej52"

ENV DOCKER_HOST unix:///tmp/docker.sock

# Configure Nginx and apply fix for very long server names
RUN sed -i 's/^http {/&\n    server_names_hash_bucket_size 128;/g' /etc/nginx/nginx.conf

# Install wget and install/updates certificates
RUN apk add --no-cache --virtual .run-deps \
    ca-certificates bash wget \
    && update-ca-certificates

RUN wget --quiet https://github.com/jwilder/docker-gen/releases/download/0.7.3/docker-gen-alpine-linux-amd64-0.7.3.tar.gz \
 && tar -C /usr/local/bin -xvzf docker-gen-alpine-linux-amd64-0.7.3.tar.gz \
 && rm /docker-gen-alpine-linux-amd64-0.7.3.tar.gz

COPY root /

VOLUME ["/etc/nginx/certs"]
