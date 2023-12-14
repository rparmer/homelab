#!/bin/bash

# helm repo add metallb https://metallb.github.io/metallb

# kubectl create ns metallb-system
helm -n metallb-system upgrade -i metallb metallb/metallb -f metallb.values.yaml --create-namespace

kubectl -n metallb-system apply -f config.yaml
