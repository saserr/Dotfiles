import 'arguments::expect'
import 'file::exists'

setup::missing() {
  arguments::expect $# 'recipe'

  local recipe=$1

  ! file::exists "$HOME/.setup/$recipe"
}
