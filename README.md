TAK Server
---
deploy hardened TAK Server in a docker container using docker compose

Prerequisites
---
- You have a Platform One (P1) account and have access to the ironbank registry; https://docs-ironbank.dso.mil/quickstart/consumer-onboarding/
  - This is required to pull the images during the docker build process
- You have a tak.gov account and have access to the tak.gov artifactory; https://artifacts.tak.gov/
  - This is required to download the hardened tak server release package (e.g. takserver-docker-hardened-4.10-RELEASE-68)

Getting Started
--- 
- `Makefile` contains all the commands to build and run the docker containers; ensure the make binary is installed on your system (e.g. `sudo apt install make`)
- update .env_template with your environment variables and rename to .env
- download the tak release package (e.g. takserver-docker-hardened-4.10-RELEASE-68) from artifacts.tak.gov and place in the root directory of this project
- `make login`will login to ironbank.dso.mil (using the credentials in .env file)
- `make main` will execute the following tasks: 
  1. clean the directory of artifacts from previous builds
  




TODO
---
- [ ] create script to replace <connection password=#password# /> with ${DB_PASS} from .env file
- [ ] create script to replace cert metadata values in cert-metadata.sh script; used to create self-signed certs
- [ ] create script / logic to generate certificates from the CA container
- [ ] pull hardened postgresql image from ironbank: registry1.dso.mil/ironbank/opensource/postgres/postgresql:15.1
- [ ] create makefile to pull images from ironbank and rebuild images locally using hardened release zip from tak.gov artifactory
- [ ] use P1 "fetch-manifest-resources" to download hardening manifest resources for local docker build
- [ ] create script to download artifacts (e.g. tak hardening manifest) from https://artifacts.tak.gov/

