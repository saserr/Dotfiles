#!/usr/bin/env bash

shfmt() {
  if (($#)); then
    local paths=()
    for path in "$@"; do
      paths+=("/code/$path")
    done
    docker run -it -v "${PWD}:/code" --rm mvdan/shfmt:v3-alpine -i 2 -ci -bn -w "${paths[@]}"
  fi
}

if (($#)); then
  shfmt "$@"
else
  export -f shfmt
  shfmt lib/
  find test/ -type f -name '*.bats' \
    -not -regex 'test/helpers/mocks/.*' \
    -exec /usr/bin/env bash -c 'shfmt "$@"' {} +
  find test/ -type f -name '*.bash' \
    -not -regex 'test/helpers/mocks/.*' \
    -exec /usr/bin/env bash -c 'shfmt "$@"' {} +
fi
