FROM openresty/openresty:alpine

RUN apk add --update bash && rm -rf /var/cache/apk/*

COPY ./conf /usr/local/openresty/nginx/conf

WORKDIR /usr/local/openresty/nginx

EXPOSE 80

CMD ["/usr/local/openresty/nginx/sbin/nginx", "-c", "/usr/local/openresty/nginx/conf/nginx.conf"]
