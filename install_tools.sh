#!/bin/sh
set -eux

docker exec --user root jenkins apt update
docker exec --user root jenkins apt upgrade -y

# No special tools are required by default so far

# Setup git config otherwise we can get weird errors when syncing
docker exec jenkins git config --global user.email jenkins@sniknej.com
docker exec jenkins git config --global user.name jenkins

docker commit jenkins jenkins/jenkins:lts
