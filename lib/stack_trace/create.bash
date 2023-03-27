stack_trace::create() {
  SKIP_ON_STACK_TRACE+=()
  if ((${#SKIP_ON_STACK_TRACE[@]} == 0)); then
    __skip() { return 1; }
  else
    __skip() {
      local file
      for file in "${SKIP_ON_STACK_TRACE[@]}"; do
        [[ "$1" == "$file" ]] && return 0
      done
      return 1
    }
  fi

  STACK_TRACE=()

  local -i i=1 # skip ${BASH_SOURCE[0]} which is this file (create.bash)
  local -i size="${#BASH_SOURCE[@]}"
  while ((i < size)); do
    local file="${BASH_SOURCE[$i]}"
    if ! __skip "$file"; then
      local line="${BASH_LINENO[$i - 1]}"
      STACK_TRACE+=("at $file (line: $line)")
    fi
    i=$((i + 1))
  done
}
