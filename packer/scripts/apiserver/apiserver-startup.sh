#!/usr/bin/env bash
# This script sets up the environment for; and runs the LMap API backend.

remove_artifacts(){
  if [ "$(ls .)" ]; then
  sudo rm -R ./*
  fi
}

setup_vault(){
  vault_token=$(curl http://metadata.google.internal/computeMetadata/v1/project/attributes/vault_auth_token -H "Metadata-Flavor: Google")
  export VAULT_ADDR=http://10.0.0.3:8200
  vault auth ${vault_token}
}

create_venv(){
  export WORKON_HOME=$HOME/Envs
  mkdir -p $WORKON_HOME
  source /usr/local/bin/virtualenvwrapper.sh

  mkvirtualenv -p python3.6 lmap
}

add_github_to_known_hosts(){
  ssh-keyscan github.com >> $HOME/.ssh/known_hosts
}

create_repo_key(){
  vault read -format="json" lmap/keys | jq -r .data.lmap_repo_private_key > $HOME/.ssh/id_rsa

  #Change permissions on key file to read only
  chmod 400 $HOME/.ssh/id_rsa
}

clone_repo(){
  git clone git@github.com:andela/learning_map_api.git
  cd learning_map_api
  BUILD_COMMIT=$(curl http://metadata.google.internal/computeMetadata/v1/project/attributes/build_commit -H "Metadata-Flavor: Google")
  git checkout ${BUILD_COMMIT}
}

install_project_deps(){
  pip install -r requirements.txt
}

set_env_vars(){
  postgresdb_username=$(vault read -format="json" lmap/postgresdb | jq -r .data.lmap_db_username)
  postgresdb_password=$(vault read -format="json" lmap/postgresdb | jq -r .data.lmap_db_password)
  mail_username=$(vault read -format="json" lmap/email | jq -r .data.mail_username)
  mail_password=$(vault read -format="json" lmap/email | jq -r .data.mail_password)
  export SQLALCHEMY_DATABASE_URI=postgresql://${postgresdb_username}:${postgresdb_password}@10.0.0.6:5432/postgres
  export MAIL_USERNAME=${mail_username}
  export MAIL_PASSWORD=${mail_password}
  curl http://metadata.google.internal/computeMetadata/v1/project/attributes/learning_map_env -H "Metadata-Flavor: Google" > .env
  export $(cat .env)
  pub_key_token_verifier=$(vault read -format="json" lmap/keys | jq -r .data.lmap_token_verifier_pub_key)
  export PUBLIC_KEY=${pub_key_token_verifier}
}

migrate_db(){
  flask db upgrade
}

run_app(){
  supervisord
}

main(){
  remove_artifacts
  setup_vault
  create_venv
  add_github_to_known_hosts
  create_repo_key
  clone_repo
  install_project_deps
  set_env_vars
  migrate_db
  run_app

  #Change permissions on key file back to rw:
  sudo chmod 666 $HOME/.ssh/id_rsa
}

main "$@"
