setup::done() {
  local profile=$1

  if [ "$#" -lt 1 ]; then
    echo "Usage: ${FUNCNAME[0]} PROFILE"
    return 1
  fi

  mkdir -p ~/.setup/
  echo "1" >"$HOME/.setup/$profile"
}