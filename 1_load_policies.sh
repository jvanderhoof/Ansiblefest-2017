#!/bin/bash -ex

api_key=$(docker-compose exec conjur rails r "print Credentials['cucumber:user:admin'].api_key")

echo '--------- Load Conjur Policy ------------'
docker-compose run --rm -e CONJUR_AUTHN_API_KEY=$api_key cli policy load --replace root /src/policy/policy.yml
docker-compose run --rm -e CONJUR_AUTHN_API_KEY=$api_key cli policy load root /src/policy/groups_and_users.yml

echo '--------- Generate Host Factory Tokens ------------'
export STAGING_HFTOKEN=$(docker-compose run --rm -e CONJUR_AUTHN_API_KEY=$api_key cli hostfactory tokens create --duration-minutes=65 foo/staging | jq -r '.[0].token')
export PRODUCTION_HFTOKEN=$(docker-compose run --rm -e CONJUR_AUTHN_API_KEY=$api_key cli hostfactory tokens create --duration-minutes=65 foo/production | jq -r '.[0].token')
