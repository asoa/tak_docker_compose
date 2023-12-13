#!/bin/bash

source .env

domain=$DOMAIN
localCertDir="./certificates"
fqdn=$EXTERNAL_URL


#Create the server certificates
for server in "gitlab"
do
    fqdn="$server.$domain"
    #create the cert key
    openssl ecparam -out $localCertDir/$fqdn.key -name prime256v1 -genkey

    #create the CSR
    openssl req -new -sha256 -nodes -key $localCertDir/$fqdn.key -subj "/C=US/ST=WA/L=EN/O=Domain Local/CN=$fqdn" -out $localCertDir/$fqdn.csr

    #Generate the cert from the CSR and sign it with the CA's root key
    openssl x509 -req -extfile <(printf "subjectAltName=DNS:$fqdn") -in $localCertDir/$fqdn.csr -CA $localCertDir/$domain.crt -CAkey $localCertDir/$domain.key -CAcreateserial -out $localCertDir/$fqdn.crt -days 365 -sha256
    
    #Verify the cert
    openssl x509 -in $localCertDir/$fqdn.crt -text -noout

    #Add the CA to the Cert
    cat $localCertDir/$domain.crt >> $localCertDir/$fqdn.crt

    # move pki to gitlab directory
    if [[ $server == "gitlab" ]]; then
        mkdir -p ./$server/volumes/config/ssl; cp $localCertDir/$fqdn* ./$server/volumes/config/ssl/
    fi
done

# move the gitlab .crt to runner certs directory
mkdir -p ./runner/volumes/config/certs; cp $localCertDir/$fqdn.crt ./runner/volumes/config/certs/$fqdn.crt
