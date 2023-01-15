#!/usr/bin/env bash

bats() {
  docker run -it -v "${PWD}:/code" --rm bats/bats:latest "$@"
}

if [ "$#" -ge 1 ]; then
  bats "$@"
else
  export -f bats
  find test/ -type f -name '*.bats' -not -regex 'test/helpers/.*' -exec bash -c 'bats "$@"' {} +
fi
