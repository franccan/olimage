#!/bin/bash -eu

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
DOCKER="docker"

#APT_CACHER_NAME="olimage_apt-cacher-ng_1"
#APT_CACHER_HOST=""
#APT_CACHER_PORT="3142"
#
#NGINX_NAME="olimage_nginx_1"
#NGINX_HOST=""
#NGINX_PORT="80"

CONTAINER_NAME="olimage_work"

# Check for docker permissions
if ! ${DOCKER} ps >/dev/null 2>&1; then
	DOCKER="sudo docker"
fi

# Check for docker daemon
if ! ${DOCKER} ps >/dev/null; then
	echo "Failed to connect to docker:"
	${DOCKER} ps
	exit 1
fi

## Run apt-cacher
#if [[ "$(${DOCKER} ps -q --filter name=${APT_CACHER_NAME})" == "" ]]; then
#    if ! ${DOCKER}-compose up -d; then
#        echo "Failed to run docker-compose:"
#        ${DOCKER}-compose up
#        exit 1
#    fi
#else
#    echo "Service apt-cacher already running";
#fi
#
#APT_CACHER_HOST=$(${DOCKER} inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ${APT_CACHER_NAME})
#echo "apt-cacher listening on: ${APT_CACHER_HOST}:${APT_CACHER_PORT}"

# Build image
#docker build -t olimage "${DIR}"

docker run --rm -it --privileged \
    --name "${CONTAINER_NAME}" \
    --volume /dev:/dev \
	--volume /proc:/proc \
	--volume "$(pwd)":/olimage \
	--net 'host' \
	-e "HOST_PWD=${PWD}" \
	-w /olimage olimage \
	python3 -m olimage "$@"

#	-e "GIT_HASH=$(git rev-parse HEAD)" \
#	-e "APT_CACHER_HOST=${APT_CACHER_HOST}" \
#	-e "APT_CACHER_PORT=${APT_CACHER_PORT}" \
#	olimage
