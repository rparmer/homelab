#!/usr/bin/env bash
set -e

sealed=$(curl -s http://127.0.0.1:8200/v1/sys/seal-status | jq -r '.sealed')

if [[ "true" == ${sealed} ]]; then
    echo "unsealing vault..."
    curl -s -X POST -d "{\"key\": \"$(cat /volume1/docker/vault/keys.json | jq -r '.unseal_keys_b64[0]')\"}" --fail-with-body http://127.0.0.1:8200/v1/sys/unseal
    curl -s -X POST -d "{\"key\": \"$(cat /volume1/docker/vault/keys.json | jq -r '.unseal_keys_b64[1]')\"}" --fail-with-body http://127.0.0.1:8200/v1/sys/unseal
    curl -s -X POST -d "{\"key\": \"$(cat /volume1/docker/vault/keys.json | jq -r '.unseal_keys_b64[2]')\"}" --fail-with-body http://127.0.0.1:8200/v1/sys/unseal
fi

echo "vault unsealed"

exit 0
