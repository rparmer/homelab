#!/bin/bash

kubectl -n cert-manager delete -f letsencrypt.yaml
helm -n cert-manager delete cert-manager
# kubectl delete ns cert-manager
