#!/bin/bash

# helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/

# helm repo update
helm -n kube-system upgrade -i nfs-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner -f nfs.values.yaml
