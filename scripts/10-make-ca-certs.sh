#!/bin/bash

source .env

domain=$DOMAIN
localCertDir="./certificates"

if [ -d "$localCertDir" ]; then
    echo "certificate directory exists, deleting..."
    rm -rf $localCertDir
    mkdir $localCertDir
    #Create the root key
    openssl ecparam -out $localCertDir/$domain.key -name prime256v1 -genkey
    #Create the root certificate
    openssl req -x509 -addext basicConstraints=critical,CA:true -new -nodes -sha256 -key $localCertDir/$domain.key -subj "/C=US/ST=WA/L=EN/O=Domain Local/CN=domain.local" -out $localCertDir/$domain.crt
    #Verify the cert
    openssl x509 -in $localCertDir/$domain.crt -text -noout
else 
    echo "certificate directory does not exist, creating..."
    mkdir $localCertDir
    #Create the root key
    openssl ecparam -out $localCertDir/$domain.key -name prime256v1 -genkey
    #Create the root certificate
    openssl req -x509 -new -nodes -sha256 -key $localCertDir/$domain.key -subj "/C=US/ST=WA/L=EN/O=Domain Local/CN=${domain}.local" -out $localCertDir/$domain.crt
    #Verify the cert
    openssl x509 -in $localCertDir/$domain.crt -text -noout
fi