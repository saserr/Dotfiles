path::exists() {
  local path=$1

  if [ "$#" -lt 1 ]; then
    echo "Usage: ${FUNCNAME[0]} PATH"
    return 1
  fi

  [ -e "$path" ]
}
