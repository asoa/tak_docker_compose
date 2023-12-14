TAK Server
---
create a tak server pipeline

TODO
---
- [ ] create script to replace <connection password=#password# /> with ${DB_PASS} from .env file
- [ ] create script to replace cert metadata values in cert-metadata.sh script; used to create self-signed certs
- [ ] create script / logic to generate certificates from the CA container
- [ ] pull hardened postgresql image from ironbank: registry1.dso.mil/ironbank/opensource/postgres/postgresql:15.1
- [ ] create makefile to pull images from ironbank and rebuild images locally using hardened release zip from tak.gov artifactory
- [ ] use P1 "fetch-manifest-resources" to download hardening manifest resources for local docker build
- [ ] create script to download artifacts (e.g. tak hardening manifest) from https://artifacts.tak.gov/

