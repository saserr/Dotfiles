#!/usr/bin/env bash

check() {
  shellcheck -f gcc "$@"
}

if (($#)); then
  check "$@"
else
  export -f check
  declare -i status=0
  check -x setup.sh shellcheck.sh shfmt.sh test.sh || status=$?
  find lib/ -type f -name '*.bash' \
    -exec /usr/bin/env bash -c 'check "$@"' {} + || status=$?
  find recipes/ -type f -name '*.bash' \
    -not -regex 'test/helpers/mocks/.*' \
    -exec /usr/bin/env bash -c 'check -e SC2034 "$@"' {} + || status=$?
  find test/ -type f -name '*.bash' \
    -not -regex 'test/helpers/mocks/.*' \
    -exec /usr/bin/env bash -c 'check "$@"' {} + || status=$?
  exit $status
fi
