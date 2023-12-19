TAK Server
---
Project Summary: deploy a hardened TAK Server in docker containers using docker compose in 5 minutes

Prerequisites
---
- A Platform One (P1) account and have access to the ironbank registry; https://docs-ironbank.dso.mil/quickstart/consumer-onboarding/
  - This is required to pull the images during the docker build process
- A tak.gov account and have access to the tak.gov artifactory; https://artifacts.tak.gov/
  - This is required to download the hardened tak server release package (e.g. takserver-docker-hardened-4.10-RELEASE-68)
- clone this repo to your local machine and ensure **takserver-docker-hardened-4.10-RELEASE-68.zip** is in the root directory of this project
- ensure the make binary is installed on your system (e.g. `sudo apt install make`)

Getting Started
--- 
- `Makefile` contains all the commands to build and run the docker containers
- update .env_template with your environment variables and rename to .env
- download the tak release package (e.g. takserver-docker-hardened-4.10-RELEASE-68) from artifacts.tak.gov and place in the root directory of this project
- `make login`will login to ironbank.dso.mil (using the credentials in .env file)
- `make main` will execute the following tasks: 
  1. clean the directory of artifacts from previous builds
  2. unzip the tak release package
  3. edit the tak release package configs (e.g. CoreConfig.xml, db-utils/pg_hba.conf, certs/cert-metadata.sh)
  4. build the docker images (will pull from P1 if images are not present locally)
  5. run the docker containers

![](documentation/demo.gif)

- `make add_user` will add the admin user certificate to the tak server
- scp the admin user certificate from the tak server container to your local machine with 
  - ```scp root@<tak_server_ip:/root/tak/files/admin.p12 .```
- import the admin.p12 certificate into your browser and browse to https://<tak_server_ip>:8443

![](documentation/demo2.gif)

- stop and remove the docker containers, volumes, and network with `make down`


TODO
---
- [x] create script to replace <connection password=#password# /> with ${DB_PASS} from .env file
- [x] create script to replace cert metadata values in cert-metadata.sh script; used to create self-signed certs
- [x] create script / logic to generate certificates from the CA container
- [x] pull hardened postgresql image from ironbank: registry1.dso.mil/ironbank/opensource/postgres/postgresql:15.1
- [x] create makefile to pull images from ironbank and rebuild images locally using hardened release zip from tak.gov artifactory
- [ ] use P1 "fetch-manifest-resources" to download hardening manifest resources for local docker build
- [ ] create script to download artifacts (e.g. tak hardening manifest) from https://artifacts.tak.gov/
- [ ] create gitlab-ci pipeline to pull images from ironbank and rebuild images locally using a gitlab runner with the [kaniko](https://github.com/GoogleContainerTools/kaniko) executor
- [ ] sync docker images built from gitlab-ci pipeline to a local registry deployed on edge compute (e.g. Azure Stack Edge, AWS Snowball, Klas Voyager, etc.)

