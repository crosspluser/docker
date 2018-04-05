FROM redis:3.2.11-alpine

RUN apk add --update bash && rm -rf /var/cache/apk/*

COPY ./etc/redis/redis.conf /etc/redis/redis.conf
