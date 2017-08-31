#!/bin/bash -ex

docker-compose up --build -d
docker-compose scale foo_staging=2 foo_production=4

# sleep 10
# for i in $(seq 20); do
#   curl -o /dev/null -fs -X OPTIONS http://localhost:3000 > /dev/null && echo "server is up" && break
#   echo "."
#   sleep 2
# done
