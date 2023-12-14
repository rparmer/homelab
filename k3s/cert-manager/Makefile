.PHONY: add-helm-repo
add-helm-repo:
	helm repo add jetstack https://charts.jetstack.io 

.PHONY: apply
apply:
	helm -n cert-manager upgrade -i cert-manager jetstack/cert-manager --set installCRDs=true --create-namespace
	kubectl -n cert-manager apply -f letsencrypt.yaml
