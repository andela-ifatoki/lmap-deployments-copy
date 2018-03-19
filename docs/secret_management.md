# Secret Management

## Tech stack

- Hashicorp Vault
- Ubuntu xenial

## Getting started.

- Clone the infrastructure repository to your local box
- Download the json credentials from the LMap project console on Google Cloud Platform.
- Add the credentials to the root of the repo in the `gcp-account.json` file.
- Run the following commands to log into the `nat-api-instance` which acts as the bastion host to access the internal networks:
	- `gcloud init` so as to set up the configuration credentials of the LMap application locally.
	- `gcloud beta compute ssh nat-api-instance --zone "<vm-zone>"`.
	- `gcloud beta compute ssh lmap-vault-server --internal-ip`

## Initial Setup

This section of Vault setup only needs to happen once;

#### Initialize vault
- `export VAULT_ADDR=http://10.0.0.3:8200`
- `vault init`; This command will generate 5 shards of keys that are to be used in unsealing the vault along with 1 root token which must only be used during the initial setup and then revoked.
- The 5 keys and the root token must be kept safely as losing them would mean that the vault can never be unsealed and the secret inside will remain forever inaccessible.

#### Unseal vault

Unsealing the vault means that the vault contents are no longer encrypted. However, this does not mean they are accessible just yet. For that you need to authenticate to the Vault service using the root token. To unseal vault, one needs to run the command below 3 times with 3 of the 5 shard keys that were generated in the previous command.
- `vault unseal <shard-key>`

#### Authenticate to Vault

This is the step that allows you to perform actions against the Vault backend. The access is time limited by default to 768Hrs after which time, the authentication will have to happen again.
- `vault auth <root-token>`


## Setting up Vault for LMap

#### Setting up policy

This refers to the capabilities that a particular user setup on Vault will have against the data or resources of the Vault backend.
The policy that LMap API instances use is hard baked in the Vault server's base image in `/home/packer/lmap-vault-policy.hcl`
```
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
```
This policy means that what ever account is attached to this policy will be able to only `read` data from the Vault backend.

Run `vault policy-write lmap-policy /home/packer/lmap-vault-policy.hcl` to create a policy called `lmap-policy`.

## Usage

### CLI
#### Mounting a secret backend
`vault mount -path=lmap kv `  
This mounts a `key-value` type filesystem at the path `lmap/` which will act as the root for writing the LMap secrets.
LMap has 4 secrets stored in vault:
- *lmap_db_username*: Username the LMap application uses to access the main database.
- *lmap_db_password*: Password associated with above username.
- *lmap_token_verifier_pub_key*: Used by the CALM API to verify received tokens.
- *lmap_repo_private_key*: Private key that allows cloning of latest commit from source control on github.
- *mail_username*: Email for sending mail notifications.
- *mail_password*: Password associated with `mail_username`.
#### Write to secret backend
* `vault write lmap/postgresdb lmap_db_username=<main_postgresdb_username> lmap_db_password=<main_postgresdb_password>`  
*lmap_token_verifier_pub_key* and *lmap_repo_private_key* are files and can be written into vault directly using: 

* `vault write lmap/keys lmap_token_verifier_pub_key=@public_key.file lmap_repo_private_key=@private_key.file`

* `vault write lmap/email mail_username=@email.file mail_password=@password.file`
#### Read secret backend
* `vault read lmap/postgresdb`

* `vault read lmap/keys`

* `vault read lmap/email`

### HTTP API

#### Write to secret backend

```
curl -X POST -H "X-Vault-Token: <root-token>" \
     http://10.0.0.3:8200/v1/lmap/postgresdb/ \
     -d {"lmap_db_username": "<main_postgresdb_username>", "lmap_db_password": "<main_postgresdb_password"}
```

#### Read secret backend

```
curl -X GET -H "X-Vault-Token: <root-token>" \
     http://10.0.0.3:8200/v1/lmap/postgresdb/
```

#### Token generation
The root token is very powerful due to the amount of access and control it has over the secret management infrastructure in Vault, as such it is **highly** advisable not to have it publicly shared or even ever used at all. To avoid compromising the secrecy of the information stored and thus the security of the entire system, tokens are created with more focused access permissions that are only limited to what the token will be used for. Policies come in handy to do this.  
`vault token-create -policy=lmap-policy`
The generated token is what the *api instances* use to read the secrets from the *vault server*.
It is set as the metadata *vault_auth_token*
