.PHONY: add-helm-repo
add-helm-repo:
	helm repo add external-secrets https://charts.external-secrets.io

.PHONY: apply
apply:
	helm -n external-secrets upgrade -i external-secrets external-secrets/external-secrets --create-namespace
	kubectl apply -f secretStores.yaml
