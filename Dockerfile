FROM python:3.8

WORKDIR /root/

RUN apt-get update && apt-get upgrade && apt-get install -y libleveldb-dev curl gpg ca-certificates tar dirmngr

RUN curl -o pepecoin.tar.gz -Lk https://github.com/pepecoinppc/pepecoin/releases/download/v1.0.1/pepecoin-1.0.1-x86_64-linux-gnu.tar.gz

RUN tar -xvf pepecoin.tar.gz

RUN rm pepecoin.tar.gz

RUN install -m 0755 -o root -g root -t /usr/local/bin pepecoin-1.0.1/bin/*

RUN pip install uvloop

RUN git clone https://github.com/PepeEnthusiast/electrumx-pepecoin.git \
    && cd electrumx-pepecoin \
    && pip3 install .

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN mkdir -p /root/.pepecoin
COPY pepecoin.conf /root/.pepecoin/pepecoin.conf

VOLUME ["/data"]

ENV HOME /data
ENV ALLOW_ROOT 1
ENV COIN=Pepecoin
ENV DAEMON_URL=http://pepe:epep@127.0.0.1:22555
ENV EVENT_LOOP_POLICY uvloop
ENV DB_DIRECTORY /data
ENV SERVICES=tcp://:50001,ssl://:50002,wss://:50004,rpc://0.0.0.0:8000
ENV SSL_CERTFILE ${DB_DIRECTORY}/electrumx-pepecoin.crt
ENV SSL_KEYFILE ${DB_DIRECTORY}/electrumx-pepecoin.key
ENV HOST ""

WORKDIR /data

EXPOSE 50001 50002 50004 8000

ENTRYPOINT ["/entrypoint.sh"]