import 'arguments::expect'

log() {
  arguments::expect $# 'color' 'tag' 'message' '...'

  local color="\033[${1}m"
  local tag=$2
  local messages=("${@:3}")

  local end_color='\033[0m'
  echo -e "${color}[$tag]$end_color ${messages[0]}"

  if ((${#messages[@]} > 1)); then
    local identation
    identation="$(printf " %.0s" $(seq 1 $((${#tag} + 2))))"

    local message
    local messages=("${messages[@]:1}")
    for message in "${messages[@]}"; do
      echo "$identation $message"
    done
  fi
}
