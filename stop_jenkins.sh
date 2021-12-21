#!/bin/sh
set -eux

ROOT_PATH="$(realpath $(dirname $0))"

kill -9 $(cat "$ROOT_PATH/jenkins.pid")
rm "$ROOT_PATH/jenkins.pid"
