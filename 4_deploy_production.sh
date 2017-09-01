#!/bin/bash -e

cd ansible

ansible-galaxy install -r requirements.yml

echo '--------- Generate a Host Factory Token ------------'
api_key=$(docker-compose exec conjur rails r "print Credentials['cucumber:user:admin'].api_key")
hf_token=$(docker-compose run --rm -e CONJUR_AUTHN_API_KEY=$api_key conjur_cli \
  hostfactory tokens create --duration-minutes=5 production/myapp | jq -r '.[0].token')

echo '--------- Run Playbook ------------'
PRODUCTION_HFTOKEN="$hf_token" ansible-playbook -i ./inventory playbooks/myapp-production.yml
