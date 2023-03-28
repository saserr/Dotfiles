import 'arguments::expect'

setup::file() {
  arguments::expect $# 'recipe'

  local recipe=$1

  local default_state_home="$HOME/.local/state"
  echo "${XDG_STATE_HOME:-$default_state_home}/dotfiles/$recipe"
}
