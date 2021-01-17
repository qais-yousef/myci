#!/bin/sh
set -eux

JENKINS_HOME="`realpath $(dirname $0)`"/jenkins_home

docker run \
  --name jenkins \
  --rm \
  --detach \
  --network jenkins \
  --env DOCKER_HOST=tcp://docker:2376 \
  --env DOCKER_CERT_PATH=/certs/client \
  --env DOCKER_TLS_VERIFY=1 \
  --publish 8080:8080 \
  --publish 8888:8888 \
  --publish 50000:50000 \
  --volume /dev/bus/usb:/dev/bus/usb \
  --volume "$JENKINS_HOME":/var/jenkins_home \
  --volume jenkins-docker-certs:/certs/client:ro \
  jenkins/jenkins:lts
