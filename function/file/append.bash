file::append() {
  local file=$1
  local text=$2

  if [ "$#" -lt 1 ]; then
    echo "Usage: ${FUNCNAME[0]} FILE [TEXT]"
    return 1
  fi

  echo "$text" >>"$file"
}