#!/usr/bin/env bash

set -o errexit
set -o xtrace
set -o pipefail


initialize_vault() {
  export VAULT_ADDR=http://10.0.0.3:8200
}

authenticate() {
  TOKEN=$( curl http://metadata.google.internal/computeMetadata/v1/project/attributes/pass -H "Metadata-Flavor: Google" | base64 --decode )
  vault auth ${TOKEN}
}

create_lmap_policy() {
  vault policy-write lmap-policy /home/packer/lmap-vault-policy.hcl
}

generate_new_token() {
  REFRESH_TOKEN=$( vault token-create -policy=lmap-policy | sed -n 3p | cut -d' ' -f 11 | sed 's/^[ \t]*//;s/[ \t]*$//' )
}

update_token() {
  gcloud compute project-info add-metadata --metadata vault_auth_token=${REFRESH_TOKEN}
}

main() {
  initialize_vault
  authenticate
  create_lmap_policy
  generate_new_token
  update_token
}

main "$@"
