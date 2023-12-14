#!/bin/bash

# https://github.com/kubernetes/ingress-nginx/tree/main/charts/ingress-nginx
# helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

# kubectl create ns ingress-nginx

# helm repo update
helm -n ingress-nginx upgrade -i ingress-nginx ingress-nginx/ingress-nginx -f nginx.values.yaml --create-namespace
