#!/bin/bash -e

api_key=$(docker-compose exec conjur rails r "print Credentials['demo-policy:user:admin'].api_key")

echo '--------- Set Secrets defined in Policy ------------'

staging_pass=$(openssl rand -hex 12)
staging_key=$(openssl rand -hex 60)
prod_pass=$(openssl rand -hex 12)
prod_key=$(openssl rand -hex 60)

docker-compose run --rm -e CONJUR_AUTHN_API_KEY=$api_key --entrypoint /bin/bash conjur_cli -c "
  echo \"Setting staging/myapp/database/username to 'foo_staging_user'\"
  conjur variable values add staging/myapp/database/username foo_staging_user

  echo \"Setting staging/myapp/database/password to '$staging_pass'\"
  conjur variable values add staging/myapp/database/password \"$staging_pass\"

  echo \"Setting staging/myapp/stripe/private_key to '$staging_key'\"
  conjur variable values add staging/myapp/stripe/private_key \"$staging_key\"

  echo \"Setting production/myapp/database/username to 'foo_production_user'\"
  conjur variable values add production/myapp/database/username foo_production_user

  echo \"Setting production/myapp/database/password to '$prod_pass'\"
  conjur variable values add production/myapp/database/password \"$prod_pass\"

  echo \"Setting production/myapp/stripe/private_key to '$prod_key'\"
  conjur variable values add production/myapp/stripe/private_key \"$prod_key\"
"
