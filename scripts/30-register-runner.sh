#!/usr/bin/env bash
source .env
# export your registration token to your session before running this script
# export REGISTRATION_TOKEN="XXXXXXXX

GITLAB_URL="https://$EXTERNAL_URL"
DOCKER_NETWORK=$(docker network ls | grep gitlab | awk 'NR==1{print $2}')
DOCKER_VERSION=docker:24.0.6

# no registration token provided, setting up script for unregistering runners
if [[ $1 == "unregister" ]]; then 
  echo "Unregistering all runners"
  runner=$(docker ps | grep base_runner | awk 'NR==1{print $1}')
  docker exec $runner gitlab-runner unregister --all-runners
  exit 0
fi 

# arguments provided for token and runner type; registering runner 
BASE_RUNNERS=$(docker ps | grep base_runner | awk ' { print $1 } ')
DOCKER_RUNNERS=$(docker ps | grep docker_runner | awk ' { print $1 } ')

case "$1" in
  "base")
    echo "Registering local shell runners"
    for runner in ${BASE_RUNNERS[@]}; do
      echo "Registering runner $runner"
      docker exec $runner gitlab-runner register \
        --non-interactive \
        --executor "shell" \
        --docker-network-mode $DOCKER_NETWORK \
        --url $GITLAB_URL \
        --registration-token $REGISTRATION_TOKEN \
        --description $runner \
        --tag-list "base" \
        --run-untagged="true" \
        --locked="false" \
        --access-level="not_protected" \
        --tls-ca-file "/etc/gitlab-runner/certs/gitlab.${DOMAIN%.local}.local.crt"
    done
    ;;
  "docker")
    echo "Registering docker runners"
    for runner in ${DOCKER_RUNNERS[@]}; do
      echo "Registering runner $runner"
      docker exec $runner gitlab-runner register \
        --non-interactive \
        --executor "docker" \
        --docker-image $DOCKER_VERSION \
        --docker-network-mode $DOCKER_NETWORK \
        --url $GITLAB_URL \
        --registration-token $REGISTRATION_TOKEN \
        --description $runner \
        --tag-list "docker" \
        --run-untagged="true" \
        --locked="false" \
        --access-level="not_protected" \
        --tls-ca-file /etc/gitlab-runner/certs/gitlab.${DOMAIN%.local}.local.crt \
        # --docker-privileged \ # removing for kaniko
    done
    ;;
  *)
    echo "Usage: export REGISTRATION_TOKEN=<registration_token>"
    echo "Usage: ./script <base | docker>"
    echo "Usage: ./script unregister"

esac
