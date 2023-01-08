text::repeat() {
  local times=$1
  local text=$2

  if [ "$#" -lt 2 ]; then
    echo "Usage: ${FUNCNAME[0]} TIMES TEXT"
    return 1
  fi

  if [ "$times" -gt 0 ]; then
    printf "$text%.0s" $(seq 1 "$times")
  fi
}