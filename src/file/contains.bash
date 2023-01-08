file::contains() {
  local file=$1
  local text=$2

  if [ "$#" -lt 2 ]; then
    echo "Usage: ${FUNCNAME[0]} FILE TEXT"
    return 1
  fi

  grep -q "$text" "$file"
}