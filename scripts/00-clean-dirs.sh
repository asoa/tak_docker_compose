#!/usr/bin/env bash

source .env

if [[ -d ${TAK_RELEASE} ]]; then
  rm -rf ${TAK_RELEASE}
fi

if [[ -d ${HUB_RELEASE} ]]; then
  rm -rf ${HUB_RELEASE}
fi

#docker_files=$(ls Dockerfile.* 2>/dev/null | wc -l)
#if [[ ${docker_files} -gt 0 ]]; then
#  rm -rf Dockerfile.*
#fi

if [[ -d files ]]; then
  rm -rf files
fi
