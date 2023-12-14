#!/bin/bash

VERSION="${@}"

if [ -z $VERSION ]; then
  echo "No version provided"
  exit 1
fi

docker buildx build --no-cache --platform linux/arm64 --build-arg VERSION=${VERSION} -t rparmer02/vault-k8s:v${VERSION}-arm --load .
docker push rparmer02/vault-k8s:v${VERSION}-arm
