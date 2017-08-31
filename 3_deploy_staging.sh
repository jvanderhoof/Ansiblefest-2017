#!/bin/bash -ex

cd ansible

ansible-galaxy install -r requirements.yml

echo '--------- Generate Host Factory Tokens ------------'
api_key=$(docker-compose exec conjur rails r "print Credentials['cucumber:user:admin'].api_key")
hf_token=$(docker-compose run --rm -e CONJUR_AUTHN_API_KEY=$api_key cli hostfactory tokens create --duration-minutes=5 foo/staging | jq -r '.[0].token')

echo '--------- Run Playbook ------------'
STAGING_HFTOKEN="$hf_token" ansible-playbook -i ./inventory playbooks/foo-staging.yml
