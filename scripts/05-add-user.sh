#!/usr/bin/env bash

source .env

fingerprint=$(docker exec -it ca-setup-hardened bash -c "openssl x509 -noout -fingerprint -md5 -inform pem -in files/admin.pem | grep -oP 'MD5 Fingerprint=\K.*'")

command="java -jar /opt/tak/utils/UserManager.jar usermod -A -f $fingerprint admin"

docker exec -it takserver-hardened bash -c "$command"

# add user to fedhub

path_to_cert="/opt/tak/federation-hub/certs/files/admin.pem"
command="java -jar /opt/tak/federation-hub/jars/federation-hub-manager.jar ${path_to_cert}"

docker exec -it hub bash -c "$command"
