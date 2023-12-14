#!/bin/bash

helm delete vault
kubectl delete -f ingress.yaml
