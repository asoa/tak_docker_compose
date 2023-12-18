#!/usr/bin/env bash

source .env

if [[ -d ${RELEASE} ]]; then
  rm -rf ${RELEASE}
fi

if [[ -f Dockerfile.ca ]]; then
  rm Dockerfile.ca
fi

if [[ -f Dockerfile.hardened-takserver ]]; then
  rm Dockerfile.hardened-takserver
fi

if [[ -f Dockerfile.hardened-takserver-db ]]; then
  rm Dockerfile.hardened-takserver-db
fi

if [[ -d files ]]; then
  rm -rf files
fi

