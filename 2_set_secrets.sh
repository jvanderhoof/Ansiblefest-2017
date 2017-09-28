#!/bin/bash -e

api_key=$(docker-compose exec conjur rails r "print Credentials['cucumber:user:admin'].api_key")

echo '--------- Set Secrets defined in Policy ------------'

docker-compose run --rm -e CONJUR_AUTHN_API_KEY=$api_key conjur_cli \
  variable values add staging/myapp/database/username foo_staging_user
echo "Setting 'staging/myapp/database/username' to 'foo_staging_user'"

pass=$(openssl rand -hex 12)
echo "Setting 'staging/myapp/database/password' to '$pass'"
docker-compose run --rm -e CONJUR_AUTHN_API_KEY=$api_key conjur_cli \
  variable values add staging/myapp/database/password "$pass"

key=$(openssl rand -hex 60)
echo "Setting 'staging/myapp/stripe/private_key' to '$key'"
docker-compose run --rm -e CONJUR_AUTHN_API_KEY=$api_key conjur_cli \
  variable values add staging/myapp/stripe/private_key "$key"

echo "Setting 'production/myapp/database/username' to 'foo_production_user'"
docker-compose run --rm -e CONJUR_AUTHN_API_KEY=$api_key conjur_cli \
  variable values add production/myapp/database/username foo_production_user

pass=$(openssl rand -hex 12)
echo "Setting 'production/myapp/database/password' to '$pass'"
docker-compose run --rm -e CONJUR_AUTHN_API_KEY=$api_key conjur_cli \
  variable values add production/myapp/database/password "$pass"

key=$(openssl rand -hex 60)
echo "Setting 'production/myapp/stripe/private_key' to '$key'"
docker-compose run --rm -e CONJUR_AUTHN_API_KEY=$api_key conjur_cli \
  variable values add production/myapp/stripe/private_key "$key"
