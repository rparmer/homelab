#!/bin/bash

# kubectl delete -f ingress.yaml
helm uninstall consul
kubectl delete secret consul-bootstrap-acl-token
kubectl delete secret consul-client-acl-token
kubectl delete secret consul-connect-inject-acl-token
kubectl delete secret consul-controller-acl-token
kubectl delete secret consul-mesh-gateway-acl-token
kubectl delete secret consul-acl-replication-acl-token
kubectl delete secret consul-federation
kubectl delete pvc data-default-consul-server-0
kubectl delete pvc data-default-consul-server-1
