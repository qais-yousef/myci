#!/bin/bash
set -eux

JENKINS_HOME="`realpath $(dirname $0)`"/jenkins_home

docker run --detach -t -v myci-jenkins-home:/var/jenkins_home --name jenkins_home busybox sh
docker cp $JENKINS_HOME jenkins_home:/var/
docker exec jenkins_home chown -R 1000:1000 /var/jenkins_home
docker stop jenkins_home
docker rm jenkins_home
