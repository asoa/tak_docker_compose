#!/usr/bin/env bash

source .env

if [[ -d ${TAK_RELEASE} ]]; then
  rm -rf ${TAK_RELEASE}
fi

if [[ -d ${HUB_RELEASE} ]]; then
  rm -rf ${HUB_RELEASE}
fi

if [[ -d files ]]; then
  rm -rf files
fi
