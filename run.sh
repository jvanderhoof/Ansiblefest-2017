#!/bin/bash -ex

docker-compose up -d
docker-compose scale foo_staging=2 foo_production=4

sleep 10
for i in $(seq 20); do
  curl -o /dev/null -fs -X OPTIONS http://localhost:3000 > /dev/null && echo "server is up" && break
  echo "."
  sleep 2
done

source '1_load_policies.sh'

api_key=$(docker-compose exec conjur rails r "print Credentials['cucumber:user:admin'].api_key")

docker-compose run --rm -e CONJUR_AUTHN_API_KEY=$api_key cli variable values add foo/staging/database/username foo_staging_user
docker-compose run --rm -e CONJUR_AUTHN_API_KEY=$api_key cli variable values add foo/staging/database/password "$(openssl rand -hex 12)"
docker-compose run --rm -e CONJUR_AUTHN_API_KEY=$api_key cli variable values add foo/staging/stripe/private_key "$(openssl rand -hex 60)"
