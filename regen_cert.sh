#!/bin/sh
set -x

SCRIPTS_PATH="$(realpath $(dirname $0))"

# Generate a selfsigned certificate for https
CERTS_PATH="$SCRIPTS_PATH"/certs
KEY_PASS_FILE="$CERTS_PATH"/jenkins_keystore.pass
KEY_FILE="$CERTS_PATH"/jenkins_keystore.jks
KEY_FILE_JHOME="$SCRIPTS_PATH"/jenkins_home/jenkins_keystore.jks
PKCS12_FILE="$CERTS_PATH"/jenkins_cert.p12
PEM_FILE="$CERTS_PATH"/jenkins_cert.pem
san="$1"

rm $KEY_FILE $PKCS12_FILE $PEM_FILE

# We are about to add a new file there, so sync before we push the new file
./pull_jenkins_home.sh

if [ ! -e $KEY_PASS_FILE ]; then
    openssl rand -base64 32 > $KEY_PASS_FILE
    chmod 600 key.pass
fi

if [ "x$san" != "x" ]; then
	san="-ext san=$san"
else
	san=""
fi

if [ ! -e $KEY_FILE ]; then
	keytool -genkey -keyalg RSA -alias selfsigned \
		-keystore $KEY_FILE \
		-storepass $(cat $KEY_PASS_FILE) \
		$san \
		-keysize 4096

	cp $KEY_FILE $KEY_FILE_JHOME
fi

if [ ! -e $PKCS12_FILE ]; then
	yes $(cat $KEY_PASS_FILE) | \
		keytool -importkeystore -srckeystore $KEY_FILE \
	       -destkeystore $PKCS12_FILE \
	       -srcstoretype jks \
	       -deststoretype pkcs12
fi

if [ ! -e $PEM_FILE ]; then
	openssl pkcs12 -in $PKCS12_FILE -out $PEM_FILE -passin "pass:$(cat $KEY_PASS_FILE)" -passout "pass:$(cat $KEY_PASS_FILE)"
fi

# Push the updated certs to jenkins_home
./push_jenkins_home.sh
