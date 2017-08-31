#!/bin/bash -ex

api_key=$(docker-compose exec conjur rails r "print Credentials['cucumber:user:admin'].api_key")

echo '--------- Load Conjur Policy ------------'
docker-compose run --rm -e CONJUR_AUTHN_API_KEY=$api_key cli policy load --replace root /src/policy/policy.yml
docker-compose run --rm -e CONJUR_AUTHN_API_KEY=$api_key cli policy load root /src/policy/groups_and_users.yml
