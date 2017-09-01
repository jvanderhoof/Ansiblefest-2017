#!/bin/bash -e

api_key=$(docker-compose exec conjur rails r "print Credentials['cucumber:user:admin'].api_key")

echo '--------- Load Conjur Policy ------------'
docker-compose run --rm -e CONJUR_AUTHN_API_KEY=$api_key conjur_cli \
  policy load --replace root /src/policy/users.yml

docker-compose run --rm -e CONJUR_AUTHN_API_KEY=$api_key conjur_cli \
  policy load root /src/policy/policy.yml

docker-compose run --rm -e CONJUR_AUTHN_API_KEY=$api_key conjur_cli \
  policy load staging /src/policy/apps/myapp.yml

docker-compose run --rm -e CONJUR_AUTHN_API_KEY=$api_key conjur_cli \
  policy load staging /src/policy/apps/myapp.yml

docker-compose run --rm -e CONJUR_AUTHN_API_KEY=$api_key conjur_cli \
  policy load production /src/policy/apps/myapp.yml

docker-compose run --rm -e CONJUR_AUTHN_API_KEY=$api_key conjur_cli \
  policy load root /src/policy/apps/myapp_grants.yml
