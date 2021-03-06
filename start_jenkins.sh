#!/bin/sh
set -eux

docker run \
  --name jenkins \
  --rm \
  --detach \
  --network jenkins \
  --env DOCKER_HOST=tcp://docker:2376 \
  --env DOCKER_CERT_PATH=/certs/client \
  --env DOCKER_TLS_VERIFY=1 \
  --publish 8443:8443 \
  --volume /dev/bus/usb:/dev/bus/usb \
  --volume myci-jenkins-home:/var/jenkins_home \
  --volume jenkins-docker-certs:/certs/client:ro \
  jenkins/jenkins:lts \
  --httpPort=-1 \
  --httpsPort=8443 \
  --httpsKeyStore=/var/jenkins_home/jenkins_keystore.jks \
  --httpsKeyStorePassword=$(cat certs/jenkins_keystore.pass)
