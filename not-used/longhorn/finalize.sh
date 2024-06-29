#!/bin/bash

# kubectl api-resources --verbs=list --namespaced -o name | xargs -n 1 kubectl get --show-kind --ignore-not-found -n longhorn-system --no-headers -o name > patch.txt

list=$(cat patch.txt)
IFS=$'\n'

for item in $list
do
    kubectl patch $item -p '{"metadata":{"finalizers":null}}' --type=merge
done
