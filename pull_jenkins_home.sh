#!/bin/bash
set -eux

JENKINS_HOME="`realpath $(dirname $0)`"

docker run -v myci-jenkins-home:/var/jenkins_home --name jenkins_home busybox true
docker cp jenkins_home:/var/jenkins_home $JENKINS_HOME
docker rm jenkins_home