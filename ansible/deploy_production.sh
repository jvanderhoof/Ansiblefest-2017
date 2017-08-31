#!/bin/bash -ex

ansible-galaxy install -r requirements.yml

echo '--------- Generate Host Factory Tokens ------------'
api_key=$(docker-compose exec conjur rails r "print Credentials['cucumber:user:admin'].api_key")
hf_token=$(docker-compose run --rm -e CONJUR_AUTHN_API_KEY=$api_key cli hostfactory tokens create --duration-minutes=5 foo/production | jq -r '.[0].token')

PRODUCTION_HFTOKEN="$hf_token" ansible-playbook -i ./inventory playbooks/foo-production.yml
