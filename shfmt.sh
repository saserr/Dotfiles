#!/usr/bin/env bash

shfmt() {
  if (($#)); then
    local paths=()
    for path in "$@"; do
      paths+=("/code/$path")
    done

    if [[ -t 1 ]]; then
      docker run -it -v "${PWD}:/code" --rm mvdan/shfmt:v3-alpine -i 2 -ci -bn -d "${paths[@]}"
    else
      docker run -v "${PWD}:/code" --rm mvdan/shfmt:v3-alpine -i 2 -ci -bn -d "${paths[@]}"
    fi
  fi
}

if (($#)); then
  shfmt "$@"
else
  export -f shfmt
  declare -i status=0
  shfmt setup.sh shellcheck.sh shfmt.sh test.sh || status=$?
  find lib/ recipes/ -type f -name '*.bash' \
    -exec /usr/bin/env bash -c 'shfmt "$@"' {} + || status=$?
  find test/ -type f -name '*.bash' -o -name '*.bats' \
    -not -regex 'test/helpers/mocks/.*' \
    -exec /usr/bin/env bash -c 'shfmt "$@"' {} + || status=$?
  exit $status
fi
