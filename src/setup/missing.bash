source src/path/exists.bash

setup::missing() {
  local profile=$1

  if [ "$#" -lt 1 ]; then
    echo "Usage: ${FUNCNAME[0]} PROFILE"
    return 1
  fi

  ! path::exists "$HOME/.setup/$profile"
}