#!/usr/bin/env bash

source .env

docker-compose build ca
docker-compose up -d ca

while [[ "$(docker inspect -f {{.State.Health.Status}} ca-setup-hardened)" != "healthy" ]]; do
  echo "Waiting for ca-setup-hardened to be healthy..."
  sleep 5
done

docker cp ca-setup-hardened:/tak/certs/files files 

[ -d ${RELEASE}/tak/certs/files ] || mkdir ${RELEASE}/tak/certs/files \
&& docker cp ca-setup-hardened:/tak/certs/files/takserver.jks ${RELEASE}/tak/certs/files/ \
&& docker cp ca-setup-hardened:/tak/certs/files/truststore-root.jks ${RELEASE}/tak/certs/files/ \
&& docker cp ca-setup-hardened:/tak/certs/files/fed-truststore.jks ${RELEASE}/tak/certs/files/ \
&& docker cp ca-setup-hardened:/tak/certs/files/admin.pem ${RELEASE}/tak/certs/files/ \
&& docker cp ca-setup-hardened:/tak/certs/files/config-takserver.cfg ${RELEASE}/tak/certs/files/

docker-compose build db
docker-compose build server