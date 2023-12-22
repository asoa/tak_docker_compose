#!/usr/bin/env bash

source .env

docker-compose build ca
docker-compose up -d ca

while [[ "$(docker inspect -f {{.State.Health.Status}} ca-setup-hardened)" != "healthy" ]]; do
  echo "Waiting for ca-setup-hardened to be healthy..."
  sleep 5
done

docker cp ca-setup-hardened:/tak/certs/files files 

[ -d ${TAK_RELEASE}/tak/certs/files ] || mkdir ${TAK_RELEASE}/tak/certs/files \
&& docker cp ca-setup-hardened:/tak/certs/files/takserver.jks ${TAK_RELEASE}/tak/certs/files/ \
&& docker cp ca-setup-hardened:/tak/certs/files/truststore-root.jks ${TAK_RELEASE}/tak/certs/files/ \
&& docker cp ca-setup-hardened:/tak/certs/files/fed-truststore.jks ${TAK_RELEASE}/tak/certs/files/ \
&& docker cp ca-setup-hardened:/tak/certs/files/admin.pem ${TAK_RELEASE}/tak/certs/files/ \
&& docker cp ca-setup-hardened:/tak/certs/files/config-takserver.cfg ${TAK_RELEASE}/tak/certs/files/

docker-compose build db server hubdb