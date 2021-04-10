#!/bin/bash
set -eux

JENKINS_HOME="`realpath $(dirname $0)`"/jenkins_home

docker run -v myci-jenkins-home:/var/jenkins_home --name jenkins_home busybox true
docker cp jenkins_home:/var/jenkins_home $JENKINS_HOME/..
docker rm jenkins_home

# Delete files we ignore but pulled anyway
git clean -fXdq $JENKINS_HOME

# Delete files our subkmodules ignore too
submodules="$(dirname $(find jenkins_home/jobs -maxdepth 2 -name .git))"
for sm in $submodules
do
	pushd $sm >/dev/null
	git clean -fXdq
	popd >/dev/null
done
