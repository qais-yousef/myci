#!/bin/sh
set -x

SCRIPTS_PATH="$(realpath $(dirname $0))"

# Get latest jenkins LTS
docker pull jenkins/jenkins:lts

# And busybox which we used to do some dummy stuff
docker pull busybox

# Create a network bridge
docker network create jenkins

# Create volume for TLS certificates
docker volume create jenkins-docker-certs

set -e

# Generate a selfsigned certificate for https
CERTS_PATH="$SCRIPTS_PATH"/certs
KEY_PASS_FILE="$CERTS_PATH"/jenkins_keystore.pass
KEY_FILE="$CERTS_PATH"/jenkins_keystore.jks
PKCS12_FILE="$CERTS_PATH"/jenkins_cert.p12
PEM_FILE="$CERTS_PATH"/jenkins_cert.pem
san="$1"

mkdir -p "$CERTS_PATH"

if [ ! -e "$KEY_PASS_FILE" ]; then
    openssl rand -base64 32 > "$KEY_PASS_FILE"
    chmod 600 "$KEY_PASS_FILE"
fi

if [ "x$san" != "x" ]; then
	san="-ext san=$san"
else
	san=""
fi

if [ ! -e "$KEY_FILE" ]; then
	keytool -genkey -keyalg RSA -alias selfsigned \
		-keystore "$KEY_FILE" \
		-storepass $(cat "$KEY_PASS_FILE") \
		$san \
		-keysize 4096
	cp "$KEY_FILE" "$SCRIPTS_PATH"/jenkins_home/
fi

if [ ! -e "$PKCS12_FILE" ]; then
	yes $(cat "$KEY_PASS_FILE") | \
		keytool -importkeystore -srckeystore "$KEY_FILE" \
	       -destkeystore "$PKCS12_FILE" \
	       -srcstoretype jks \
	       -deststoretype pkcs12
fi

if [ ! -e "$PEM_FILE" ]; then
	openssl pkcs12 -in "$PKCS12_FILE" -out "$PEM_FILE" -passin "pass:$(cat $KEY_PASS_FILE)" -passout "pass:$(cat $KEY_PASS_FILE)"
fi

"$SCRIPTS_PATH"/bin/install_tools.sh

# Create a volume for JENKINS_HOME
./refresh_jenkins_home.sh
