#!/bin/bash -e

function finish {
  echo 'Removing demo environment'
  echo '---'
  docker-compose down -v
}
trap finish EXIT

function main {
  docker-compose pull --parallel conjur conjur_cli
  docker-compose up -d conjur myapp_staging myapp_production
  docker-compose scale myapp_staging=2 myapp_production=4
  docker-compose logs -f conjur myapp_staging myapp_production
}

main
