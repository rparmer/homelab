.PHONY: helm-update
helm-update:
	helm repo update

.PHONY: vault-apply
vault-apply:
	cd ./k3s/apps/vault && make apply

.PHONY: cert-manager-apply
cert-manager-apply:
	cd ./k3s/infrastructure/cert-manager && make apply

.PHONY: external-secrets-apply
external-secrets-apply:
	cd ./k3s/infrastructure/external-secrets && make apply

.PHONY: apply-all
apply-all: helm-update vault-apply cert-manager-apply external-secrets-apply
