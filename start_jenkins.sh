#!/bin/sh
set -eux

ROOT_PATH="$(realpath $(dirname $0))"
JENKINS_HOME="$ROOT_PATH/jenkins_home"
JENKINS_WAR="$ROOT_PATH/bin/jenkins.war"
CERTS_PATH="$ROOT_PATH/certs"

if [ -e "$ROOT_PATH/jenkins.pid" ]; then
	echo "ERROR: Already running (pid = \"$(cat $ROOT_PATH/jenkins.pid)\""
	exit 1
fi

nohup java -Duser.home="$JENKINS_HOME" -jar ${JENKINS_WAR} \
  --httpPort=-1 \
  --httpsPort=8443 \
  --httpsKeyStore="$CERTS_PATH/jenkins_keystore.jks" \
  --httpsKeyStorePassword=$(cat "$CERTS_PATH/jenkins_keystore.pass") &

echo $! > jenkins.pid
