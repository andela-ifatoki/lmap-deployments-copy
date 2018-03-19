#! /bin/bash

# Startup script for learning map frontend

# Install node
install_node() {
  curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
  sudo apt-get install -y nodejs
}

#Install yarn
install_yarn() {
        sudo npm install yarn -g
}

add_github_to_known_hosts(){
  if [ ! "$(ssh-keygen -F github.com)" ]; then
    ssh-keyscan github.com >> $HOME/.ssh/known_hosts
  fi
}

# The main function
main() {
        install_node
        install_yarn
        add_github_to_known_hosts
}

main