#!/bin/bash -e

cd ansible

env=$1

if [ "$env" = "staging" ] || [ "$env" = "production" ]; then
  ansible-galaxy install -f -r requirements.yml -p roles

  echo '--------- Generate a Host Factory Token ------------'
  api_key=$(docker-compose exec conjur rails r "print Credentials['cucumber:user:admin'].api_key")
  hf_token=$(docker-compose run --rm -e CONJUR_AUTHN_API_KEY=$api_key conjur_cli \
    hostfactory tokens create --duration-minutes=5 $env/myapp | jq -r '.[0].token')

  echo '--------- Run Playbook ------------'
  HFTOKEN="$hf_token" APP_ENV="$env" ansible-playbook "playbooks/myapp.yml"

else
  echo "'$env' is not valid option.  Please choose either 'staging' or 'production'"
fi
