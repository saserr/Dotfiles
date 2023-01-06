#!/usr/bin/env bash

docker run -it -v "${PWD}:/code" --rm bats/bats:latest test -r
