command::exists() {
  local name=$1

  if [ "$#" -lt 1 ]; then
    echo "Usage: ${FUNCNAME[0]} NAME"
    return 1
  fi

  hash "$name" 2>|/dev/null
}