#!/bin/bash

# helm repo add hashicorp https://helm.releases.hashicorp.com

helm repo update
helm upgrade -i consul hashicorp/consul -f consul.values.yaml
# kubectl apply -f ingress.yaml
kubectl patch ds consul -p '{"spec":{"template":{"spec":{"containers":[{"name":"consul","readinessProbe":{"timeoutSeconds": 10}}]}}}}'
# kubectl deploy ds consul-mesh-gateway -p '{"spec":{"template":{"spec":{"initContainers":[{"name":"service-init","readinessProbe":{"timeoutSeconds": 10}}]}}}}'
