file::empty() {
  local file=$1

  if [ "$#" -lt 1 ]; then
    echo "Usage: ${FUNCNAME[0]} FILE"
    return 1
  fi

  [ ! -s "$file" ]
}