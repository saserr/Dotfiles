source src/arguments/expect.bash

setup::done() {
  arguments::expect $# 'profile'

  local profile=$1

  mkdir -p ~/.setup/
  echo "1" >"$HOME/.setup/$profile"
}
