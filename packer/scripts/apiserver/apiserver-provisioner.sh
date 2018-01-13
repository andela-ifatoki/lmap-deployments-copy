#/bin/bash -e

# This script sets up the environment for the LMap API backend.

setup_vault(){
sudo apt-get update; sudo apt-get install jq unzip -y
sudo curl https://releases.hashicorp.com/vault/0.9.1/vault_0.9.1_linux_amd64.zip?_ga=2.64008751.1219467854.1515396614-1991659755.1513886745 -o vault.zip
unzip vault.zip
sudo mv vault /usr/local/bin/vault
}

install_env_deps(){

sudo add-apt-repository ppa:jonathonf/python-3.6 -y
sudo apt-get update; sudo apt-get install python3.6 -y

sudo apt-get install python-pip -y;
sudo apt-get install python3.6-dev -y;
pip install --upgrade pip

sudo pip install supervisor
sudo pip install virtualenvwrapper
}

add_github_to_known_hosts(){
ssh-keyscan github.com >> $HOME/.ssh/known_hosts
}


main(){
  setup_vault
  install_env_deps
  add_github_to_known_hosts
}

main
