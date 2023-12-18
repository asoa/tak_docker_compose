#!/usr/bin/env bash

source .env

# TODO: generalize sed commands to a function

source_dir=${RELEASE}/tak

function edit_core_config() {
  string_to_replace='<connection url="jdbc:postgresql://tak-database:5432/cot" username="martiuser" password="" />'
  replacement_string='<connection url=\"jdbc:postgresql://tak-database-hardened:5432/cot\" username=\"martiuser\" password=\"'"${DB_PASS}"'\" />'
  
  cp ${source_dir}/CoreConfig.example.xml ${source_dir}/CoreConfig.xml
  sed -i "s|${string_to_replace}|${replacement_string}|g" ${source_dir}/CoreConfig.xml
  chmod 666 ${source_dir}/CoreConfig.xml
}

function edit_pg_hba() {
  string_to_add="\nhost\t\tall\t\tall\t\t172.19.0.0/16\t\tmd5"
  echo -e ${string_to_add} >> ${source_dir}/db-utils/pg_hba.conf
}

# modifies path to 
function edit_dockerfiles() {
  # ca config
  sed -i "s|COPY --chown=tak:0 tak/certs/ /tak/certs|COPY --chown=tak:0 ${source_dir}/certs/ /tak/certs|g"  Dockerfile.ca
  # db config
  sed -i "s|COPY tak/security/rpms/repos/\* /etc/yum.repos.d/|COPY ${source_dir}/security/rpms/repos/* /etc/yum.repos.d/|g" Dockerfile.hardened-takserver-db
  sed -i "s|COPY tak/security/rpms/signatures /opt/signatures|COPY ${source_dir}/security/rpms/signatures /opt/signatures|g" Dockerfile.hardened-takserver-db
  sed -i "s|COPY tak/security/\*.rpm .|COPY ${source_dir}/security/*.rpm .|g" Dockerfile.hardened-takserver-db
  sed -i "s|COPY --chown=postgres:0 tak/ /opt/tak|COPY --chown=postgres:0 ${source_dir}/ /opt/tak|g" Dockerfile.hardened-takserver-db
  # server config
  sed -i "s|COPY tak/security/\*.rpm .|COPY ${source_dir}/security/*.rpm .|g" Dockerfile.hardened-takserver
  sed -i "s|COPY --chown=tak:0 tak/ /opt/tak|COPY --chown=tak:0 ${source_dir} /opt/tak|g" Dockerfile.hardened-takserver
}

main() {
  edit_core_config
  edit_pg_hba
  edit_dockerfiles
}

main
