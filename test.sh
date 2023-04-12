#!/usr/bin/env bash

if [[ "$1" == '--local' ]]; then
  shift
else
  bats() {
    if (($#)); then
      if [[ -t 1 ]]; then
        docker run -it -v "${PWD}:/code" --rm bats/bats:latest "$@"
      else
        docker run -v "${PWD}:/code" --rm bats/bats:latest "$@"
      fi
    fi
  }
  export -f bats
fi

if (($#)); then
  bats "$@"
else
  __find() {
    local platform
    platform="$(uname -s)" || exit
    case "$platform" in
      'Darwin')
        gfind "$@"
        ;;
      *)
        find "$@"
        ;;
    esac
  }

  __find test/ -type f -name '*.bats' \
    -not -regex 'test/helpers/mocks/.*' \
    -exec /usr/bin/env bash -c 'bats -j 4 --no-parallelize-within-files "$@"' {} +
fi
