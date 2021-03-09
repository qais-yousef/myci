#!/bin/bash
set -eux

docker volume rm myci-jenkins-home
docker volume create myci-jenkins-home
./push_jenkins_home.sh
