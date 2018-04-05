FROM nginx:1.13.10-alpine-perl

RUN apk add --update bash && rm -rf /var/cache/apk/*

RUN echo http://dl-2.alpinelinux.org/alpine/edge/community/ >> /etc/apk/repositories
RUN apk --no-cache add shadow && usermod -aG root nobody

COPY ./run.sh /run.sh
RUN chmod u+x /run.sh

COPY ./nginx /etc/nginx
