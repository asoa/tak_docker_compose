#!/usr/bin/env bash

source .env

fingerprint=$(docker exec -it ca-setup-hardened bash -c "openssl x509 -noout -fingerprint -md5 -inform pem -in files/admin.pem | grep -oP 'MD5 Fingerprint=\K.*'")

command="java -jar /opt/tak/utils/UserManager.jar usermod -A -f $fingerprint admin"

docker exec -it takserver-hardened bash -c "$command"