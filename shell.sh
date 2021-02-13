#!/bin/sh
set -eux

docker exec -u $(id -u) -it jenkins bash
