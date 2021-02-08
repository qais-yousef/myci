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

# Generate a selfsigned certificate for https
KEY_PASS_FILE=jenkins_keystore.pass
KEY_FILE=jenkins_home/jenkins_keystore.jks
PKCS12_FILE=jenkins_cert.p12
PEM_FILE=jenkins_cert.pem
san="$1"

if [ ! -e $KEY_PASS_FILE ]; then
    openssl rand -base64 32 > $KEY_PASS_FILE
    chmod 600 key.pass
fi

if [ "x$san" != "x" ]; then
	san="-ext san=$san"
else
	san=""
fi

keytool -genkey -keyalg RSA -alias selfsigned \
	-keystore $KEY_FILE \
	-storepass $(cat $KEY_PASS_FILE) \
	$san \
	-keysize 4096

yes $(cat $KEY_PASS_FILE) | \
	keytool -importkeystore -srckeystore $KEY_FILE \
       -destkeystore $PKCS12_FILE \
       -srcstoretype jks \
       -deststoretype pkcs12

openssl pkcs12 -in $PKCS12_FILE -out $PEM_FILE -passin "pass:$(cat $KEY_PASS_FILE)" -passout "pass:$(cat $KEY_PASS_FILE)"
