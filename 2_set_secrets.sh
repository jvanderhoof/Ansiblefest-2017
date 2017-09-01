#!/bin/bash -e

api_key=$(docker-compose exec conjur rails r "print Credentials['cucumber:user:admin'].api_key")

echo '--------- Set Secrets defined in Policy ------------'
docker-compose run --rm -e CONJUR_AUTHN_API_KEY=$api_key conjur_cli \
  variable values add staging/myapp/database/username foo_staging_user

docker-compose run --rm -e CONJUR_AUTHN_API_KEY=$api_key conjur_cli \
  variable values add staging/myapp/database/password "$(openssl rand -hex 12)"

docker-compose run --rm -e CONJUR_AUTHN_API_KEY=$api_key conjur_cli \
  variable values add staging/myapp/stripe/private_key "$(openssl rand -hex 60)"

docker-compose run --rm -e CONJUR_AUTHN_API_KEY=$api_key conjur_cli \
  variable values add production/myapp/database/username foo_production_user

docker-compose run --rm -e CONJUR_AUTHN_API_KEY=$api_key conjur_cli \
  variable values add production/myapp/database/password "$(openssl rand -hex 12)"

docker-compose run --rm -e CONJUR_AUTHN_API_KEY=$api_key conjur_cli \
  variable values add production/myapp/stripe/private_key "$(openssl rand -hex 60)"
