#!/bin/bash -ex

bundle

docker run --rm -it -p 4567:4567 -e RACK_ENV=staging jvanderhoof/ansiblefest rackup -p 4567 --host 0.0.0.0

# docker run --rm -it jvanderhoof/ansiblefest rackup --help
