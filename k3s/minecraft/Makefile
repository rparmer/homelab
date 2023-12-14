.PHONY: apply
apply:
	helm -n minecraft upgrade -i minecraft itzg/minecraft -f minecraft.values.yaml --create-namespace

.PHONY: add-helm-repo
add-helm-repo:
	helm repo add itzg https://itzg.github.io/minecraft-server-charts/

.PHONY: helm-update
helm-update:
	helm repo update
