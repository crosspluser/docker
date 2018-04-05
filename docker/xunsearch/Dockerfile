FROM cogset/xunsearch:latest

RUN apt-get update && apt-get install -y supervisor

COPY ./etc /etc
COPY ./run.sh /run.sh

EXPOSE 8383 8384

CMD /run.sh
