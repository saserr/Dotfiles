#!/usr/bin/env bash

bats() {
  if (($#)); then
    docker run -it -v "${PWD}:/code" --rm bats/bats:latest "$@"
  fi
}

if (($#)); then
  bats "$@"
else
  export -f bats
  find test/ -type f -name '*.bats' \
    -not -regex 'test/helpers/mocks/.*' \
    -exec /usr/bin/env bash -c 'bats -j 4 --no-parallelize-within-files "$@"' {} +
fi
