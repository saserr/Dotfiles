function::exists() {
  local name=$1

  if [ "$#" -lt 1 ]; then
    echo "Usage: ${FUNCNAME[0]} NAME"
    return 1
  fi

  [ "$(type -t "$name")" = 'function' ]
}
