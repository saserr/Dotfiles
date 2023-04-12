import 'abort'
import 'arguments::expect'

platform::is_root() {
  arguments::expect $# # none

  local current_user
  if ! current_user="$(id -u)"; then
    abort platform_error 'id' 'command failed'
  fi

  [[ "$current_user" == '0' ]]
}
