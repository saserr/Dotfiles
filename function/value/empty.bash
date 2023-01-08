value::empty() {
  local value=$1

  if [ "$#" -lt 1 ]; then
    echo "Usage: ${FUNCNAME[0]} VALUE"
    return 1
  fi

  [ -z "$value" ]
}
