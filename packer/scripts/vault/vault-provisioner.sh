#/bin/bash -e

# Download and install vault
download_vault(){
  sudo apt-get update
  sudo apt-get install unzip -y
  curl https://releases.hashicorp.com/vault/0.9.1/vault_0.9.1_linux_amd64.zip?_ga=2.64008751.1219467854.1515396614-1991659755.1513886745 -o vault.zip
  unzip vault.zip
  sudo mv vault /usr/local/bin/vault
}

main(){
download_vault
}
main
