#!/bin/sh
#
# To able to share jenkins_home with the docker images, current user and
# jenkins user must have the same uid and gid
set -eux

trap "docker stop jenkins" EXIT

docker run --user root --rm --detach --name jenkins jenkins/jenkins:lts
docker exec --user root jenkins sh -c "usermod -u $(id -u) jenkins"
docker exec --user root jenkins sh -c "groupmod -g $(id -g) jenkins"
docker exec --user root jenkins sh -c "chown jenkins:jenkins /var/jenkins_home"
docker commit jenkins jenkins/jenkins:lts
