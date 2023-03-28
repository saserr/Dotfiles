import 'arguments::expect'

setup::directory() {
  arguments::expect $# # none

  local default_state_home="$HOME/.local/state"
  echo "${XDG_STATE_HOME:-$default_state_home}/dotfiles"
}
