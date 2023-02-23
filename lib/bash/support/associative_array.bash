import 'arguments::expect'

bash::support::associative_array() {
  arguments::expect $# # none

  local test
  # shellcheck disable=SC2034
  # test is just a dummy name to check if 'declare -A' is supported
  test="$(declare -A _ >/dev/null 2>&1)"
}
