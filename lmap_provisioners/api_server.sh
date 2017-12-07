#!/bin/bash
# This script sets up the environment for; and runs the LMap API backend.

remove_artifacts(){
if [ "$(ls .)" ]; then
sudo rm -R ./*
fi
}

install_env_deps(){
sudo add-apt-repository ppa:jonathonf/python-3.6 -y
sudo apt-get update; sudo apt-get install python3.6 -y

sudo apt-get update;sudo apt-get install python-pip -y;
sudo apt-get update;sudo apt-get install python3.6-dev -y;
pip install --upgrade pip

sudo pip install supervisor
sudo pip install virtualenvwrapper
}

create_venv(){
export WORKON_HOME=$HOME/Envs
mkdir -p $WORKON_HOME
source /usr/local/bin/virtualenvwrapper.sh

mkvirtualenv -p python3.6 lmap
}

create_repo_key(){
curl http://metadata.google.internal/computeMetadata/v1/project/attributes/learning_map_repo_keys -H "Metadata-Flavor: Google" > $HOME/.ssh/id_rsa

#Change permissions on key file to read only
chmod 400  $HOME/.ssh/id_rsa
}

add_github_to_known_hosts(){
if [ ! "$(ssh-keygen -F github.com)" ]; then
ssh-keyscan github.com >> $HOME/.ssh/known_hosts
fi
}

clone_repo(){
git clone git@github.com:EugeneBad/learning_map_api.git
cd learning_map_api
BUILD_COMMIT=$(curl http://metadata.google.internal/computeMetadata/v1/project/attributes/build_commit -H "Metadata-Flavor: Google")
git checkout ${BUILD_COMMIT}
}

install_project_deps(){
pip install -r requirements.txt
}

set_env_vars(){
curl http://metadata.google.internal/computeMetadata/v1/project/attributes/learning_map_env -H "Metadata-Flavor: Google" > .env
export $(cat .env)
}

migrate_db(){
flask db upgrade
}

run_app(){
supervisord
}

main(){
  remove_artifacts
  install_env_deps
  create_venv
  create_venv
  create_repo_key
  add_github_to_known_hosts
  clone_repo
  install_project_deps
  set_env_vars
  migrate_db
  run_app

  #Change permissions on key file back to rw:
  sudo chmod 666 $HOME/.ssh/id_rsa
}
main
