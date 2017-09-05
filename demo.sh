#!/bin/bash -e

function finish {
  echo 'Removing demo environment'
  echo '---'
  docker-compose down -v
}
trap finish EXIT

function main() {
  docker-compose up --build -d conjur conjur_cli myapp_staging myapp_production
  docker-compose scale myapp_staging=2 myapp_production=4
  docker-compose logs -f conjur myapp_staging myapp_production
}

main
