#!/bin/bash -e

api_key=$(docker-compose exec conjur rails r "print Credentials['demo-policy:user:admin'].api_key")

echo '--------- Load Conjur Policy ------------'
docker-compose run --rm -e CONJUR_AUTHN_API_KEY=$api_key --entrypoint /bin/bash conjur_cli -c "
  conjur policy load --replace root /src/policy/users.yml
  conjur policy load root /src/policy/policy.yml
  conjur policy load staging /src/policy/apps/myapp.yml
  conjur policy load production /src/policy/apps/myapp.yml
  conjur policy load root /src/policy/application_grants.yml
"
