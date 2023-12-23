#!/usr/bin/env bash

function up() {
  deploy_hub=$1
  if [[ ${deploy_hub} == 'true' ]]; then
    echo '** Deploying TAK Server and FEDHUB **'
    docker-compose up --no-recreate -d db server hubdb hub
  else
    echo '** Deploying TAK ONLY **'
    docker-compose up --no-recreate -d db server
  fi
}

up "$@"