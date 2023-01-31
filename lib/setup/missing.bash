import 'arguments::expect'
import 'path::exists'

setup::missing() {
  arguments::expect $# 'profile'

  local profile=$1

  ! path::exists "$HOME/.setup/$profile"
}
