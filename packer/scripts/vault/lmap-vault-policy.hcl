path "lmap/keys" {
  capabilities = ["read"]
}

path "lmap/postgresdb" {
  capabilities = ["read"]
}

path "lmap/email" {
  capabilities = ["read"]
}

path "auth/token/lookup-self" {
  capabilities = ["read"]
}
