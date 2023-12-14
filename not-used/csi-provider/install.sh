#!/bin/bash

# https://github.com/kubernetes-sigs/secrets-store-csi-driver/tree/main/charts/secrets-store-csi-driver
# helm repo add secrets-store-csi-driver https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts

helm repo update
helm -n kube-system upgrade -i csi-secrets-store secrets-store-csi-driver/secrets-store-csi-driver -f csi-values.yaml