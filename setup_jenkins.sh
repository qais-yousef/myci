#!/bin/sh
set -x

# Get latest jenkins LTS
docker pull jenkins/jenkins:lts

# Create a network bridge
docker network create jenkins

# Create volume for TLS certificates
docker volume create jenkins-docker-certs

# Create volume jenkins_home
#docker volume create jenkins-home
