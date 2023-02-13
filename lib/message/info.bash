import 'arguments::expect'
import 'text::repeat'

message::info() {
  arguments::expect $# 'tag' 'message' '...'

  local tag=$1
  local messages=("${@:2}")

  local green="\e[32m"
  local end_color="\e[0m"
  echo -e "${green}[$tag]$end_color ${messages[0]}"

  if [ "${#messages[@]}" -gt 1 ]; then
    local identation
    identation="$(text::repeat $((${#tag} + 2)) ' ')"

    local messages=("${messages[@]:1}")
    for message in "${messages[@]}"; do
      echo "$identation $message"
    done
  fi
}
