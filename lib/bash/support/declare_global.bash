import 'arguments::expect'

bash::support::declare_global() {
  arguments::expect $# # none

  local test
  # shellcheck disable=SC2034
  # test is just a dummy name to check if 'declare -g' is supported
  test="$(declare -g _ >/dev/null 2>&1)"
}
