import 'arguments::expect'

platform::is_root() {
  arguments::expect $# # none

  local current_user
  current_user=$(id -u 2>&1) || return

  [[ "$current_user" == '0' ]]
}
