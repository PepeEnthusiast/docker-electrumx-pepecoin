#!/bin/bash

if [ ! -e "${SSL_CERTFILE}" ] || [ ! -e "${SSL_KEYFILE}" ]; then
  openssl req -newkey rsa:2048 -sha256 -nodes -x509 -days 365 -subj "/O=ElectrumX" -keyout "${SSL_KEYFILE}" -out "${SSL_CERTFILE}"
fi

pepecoind -conf=/root/.pepecoin/pepecoin.conf -datadir=/data 

/root/electrumx-pepecoin/electrumx_server