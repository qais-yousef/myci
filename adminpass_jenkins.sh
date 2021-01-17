#!/bin/sh
set -eux

docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
