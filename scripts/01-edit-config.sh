#!/usr/bin/env bash

source .env

tak_source_dir=${TAK_RELEASE}/tak
hub_source_dir=${HUB_RELEASE}/tak

function edit_core_config() {
  string_to_replace='<connection url="jdbc:postgresql://tak-database:5432/cot" username="martiuser" password="" />'
  replacement_string='<connection url=\"jdbc:postgresql://tak-database-hardened:5432/cot\" username=\"martiuser\" password=\"'"${DB_PASS}"'\" />'
  
  cp ${tak_source_dir}/CoreConfig.example.xml ${tak_source_dir}/CoreConfig.xml
  sed -i "s|${string_to_replace}|${replacement_string}|g" ${tak_source_dir}/CoreConfig.xml
  chmod 666 ${tak_source_dir}/CoreConfig.xml
}

function edit_pg_hba() {
  string_to_add="\nhost\t\tall\t\tall\t\t172.19.0.0/16\t\tmd5"
  echo -e ${string_to_add} >> ${tak_source_dir}/db-utils/pg_hba.conf
}

# modifies path to 
function tak_edit_dockerfiles() {
  # ca config
  sed -i "s|COPY tak/security/\*.rpm .|COPY ${tak_source_dir}/security/*.rpm .|g" Dockerfile.ca
  sed -i "s|COPY --chown=tak:0 tak/certs/ /tak/certs|COPY --chown=tak:0 ${tak_source_dir}/certs/ /tak/certs|g"  Dockerfile.ca
  # db config
  sed -i "s|COPY tak/security/rpms/repos/\* /etc/yum.repos.d/|COPY ${tak_source_dir}/security/rpms/repos/* /etc/yum.repos.d/|g" Dockerfile.hardened-takserver-db
  sed -i "s|COPY tak/security/rpms/signatures /opt/signatures|COPY ${tak_source_dir}/security/rpms/signatures /opt/signatures|g" Dockerfile.hardened-takserver-db
  sed -i "s|COPY tak/security/\*.rpm .|COPY ${tak_source_dir}/security/*.rpm .|g" Dockerfile.hardened-takserver-db
  sed -i "s|COPY --chown=postgres:0 tak/ /opt/tak|COPY --chown=postgres:0 ${tak_source_dir}/ /opt/tak|g" Dockerfile.hardened-takserver-db
  # server config
  sed -i "s|COPY tak/security/\*.rpm .|COPY ${tak_source_dir}/security/*.rpm .|g" Dockerfile.hardened-takserver
  sed -i "s|COPY --chown=tak:0 tak/ /opt/tak|COPY --chown=tak:0 ${tak_source_dir} /opt/tak|g" Dockerfile.hardened-takserver
}

function hub_edit_files() {
  # tak/federation-hub/configs/federation-hub-broker.yml
  sed -i "s|dbPassword:|dbPassword: "${HUB_DB_PASS}"|g" ${hub_source_dir}/federation-hub/configs/federation-hub-broker.yml
}

main() {
  edit_core_config
  edit_pg_hba
  tak_edit_dockerfiles
  hub_edit_files
}

main
