#!/bin/sh

docker buildx build --platform linux/amd64 -t ghcr.io/rparmer/update-cloudflare-record:latest --no-cache --push .
