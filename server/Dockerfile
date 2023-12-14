ARG IMAGE_TAG=4.10
FROM registry1.dso.mil/ironbank/tpc/tak/tak-server:${IMAGE_TAG}

RUN yum update -y && yum install -y \
  openssl

EXPOSE 8080 8443 8446 8087/tcp 8087/udp 8088 9000-9001