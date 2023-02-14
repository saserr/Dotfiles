import 'arguments::expect'
import 'path::exists'

setup::missing() {
  arguments::expect $# 'recipe'

  local recipe=$1

  ! path::exists "$HOME/.setup/$recipe"
}
