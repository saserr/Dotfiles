import 'arguments::expect'

bash::support::declare_reference() {
  arguments::expect $# # none

  local test
  # shellcheck disable=SC2034
  # test is just a dummy name to check if 'declare -A' is supported
  test="$(declare -n _='x' >/dev/null 2>&1)"
}
