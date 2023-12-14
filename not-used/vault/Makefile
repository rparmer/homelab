.PHONY: add-helm-repo
add-helm-repo:
	helm repo add hashicorp https://helm.releases.hashicorp.com

.PHONY: apply
apply:
	helm -n vault upgrade -i vault hashicorp/vault -f values.yaml --create-namespace
	kubectl -n vault apply -f authDelegator.yaml

.PHONY: create-auth
create-auth:
	vault auth enable kubernetes

.PHONY: configure-auth
configure-auth:
	vault write auth/kubernetes/config \
		token_reviewer_jwt="$(kubectl -n vault get secrets vault-auth -o jsonpath='{.data.token}' | base64 -D)" \
		kubernetes_host=https://$(kubectl -n default get svc -o jsonpath='{.items[0].spec.clusterIP}'):443 \
		kubernetes_ca_cert="$(kubectl -n vault get secrets vault-auth -o jsonpath='{.data.ca\.crt}' | base64 -D)"

.PHONY: create-read-policy
create-read-policy:
	vault policy write read-secrets policies/read-secrets.hcl

.PHONY: setup-admin
setup-admin:
	vault policy write admin policies/admin.hcl
	vault auth enable userpass
	vault write auth/userpass/users/admin \
		password="B@ndit0920" \
		policies="default,admin"

.PHONY: setup-external-secrets
setup-external-secrets:
	vault write auth/kubernetes/role/external-secrets \
		bound_service_account_names=external-secrets \
		bound_service_account_namespaces="*" \
		policies=read-secrets \
		ttl=1h

.PHONY: setup
setup: create-auth configure-auth setup-admin create-read-policy setup-external-secrets
