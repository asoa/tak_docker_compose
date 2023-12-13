#!/bin/bash

# This script builds the dir structure
DIRS=("ca" "db" "server" "hub")
WORKDIR=$(pwd)

log() {
  echo "LOG - $1"
}

error() {
  echo "** ERROR - $1 **"
}

createFileTree() {
    for dir in "${DIRS[@]}"; do
        if [[ -d $WORKDIR/$dir ]] && [[ -f $WORKDIR/$dir/Dockerfile ]]; then
            echo "~/$dir/Dockerfile already exists"
        else
            mkdir $WORKDIR/$dir && touch $WORKDIR/$dir/Dockerfile
        fi
        # if dir is gitlab, create subdirs
        if [[ $dir == "gitlab" ]] && [[ ! -d $WORKDIR/$dir/volumes ]]; then
            mkdir -p $WORKDIR/$dir/volumes/{config,data,logs}
        fi
        # if dir is runner, create subdirs
        if [[ $dir == "runner" ]] && [[ ! -d $WORKDIR/$dir/volumes ]]; then
            mkdir -p $WORKDIR/$dir/volumes/config/certs
        fi
    done
}

main() {
  createFileTree
}

main "$@"