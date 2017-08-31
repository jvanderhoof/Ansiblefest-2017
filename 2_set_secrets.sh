#!/bin/bash -ex

api_key=$(docker-compose exec conjur rails r "print Credentials['cucumber:user:admin'].api_key")

echo '--------- Set Secrets defined in Policy ------------'
docker-compose run --rm -e CONJUR_AUTHN_API_KEY=$api_key cli variable values add foo/staging/database/username foo_staging_user
docker-compose run --rm -e CONJUR_AUTHN_API_KEY=$api_key cli variable values add foo/staging/database/password "$(openssl rand -hex 12)"
docker-compose run --rm -e CONJUR_AUTHN_API_KEY=$api_key cli variable values add foo/staging/stripe/private_key "$(openssl rand -hex 60)"

docker-compose run --rm -e CONJUR_AUTHN_API_KEY=$api_key cli variable values add foo/production/database/username foo_production_user
docker-compose run --rm -e CONJUR_AUTHN_API_KEY=$api_key cli variable values add foo/production/database/password "$(openssl rand -hex 12)"
docker-compose run --rm -e CONJUR_AUTHN_API_KEY=$api_key cli variable values add foo/production/stripe/private_key "$(openssl rand -hex 60)"
