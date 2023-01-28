source src/arguments/expect.bash
source src/path/exists.bash

setup::missing() {
  arguments::expect $# 'profile'

  local profile=$1

  ! path::exists "$HOME/.setup/$profile"
}
