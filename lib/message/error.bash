# Do not import any other functions because the import function depens on
# message::error.

message::error() {
  if { type -t 'arguments::expect' &>/dev/null && arguments::expect $# 'tag' 'message' '...'; } ||
    [ $# -gt 1 ]; then
    local tag=$1
    local messages=("${@:2}")
  else
    local tag='message::error'
    local messages=('requires tag and one or more messages as arguments')
    if [ ${#BASH_SOURCE[@]} -gt 1 ]; then
      local file="${BASH_SOURCE[1]}"
      local line="${BASH_LINENO[0]}"
      messages+=("at $file (line: $line)")
    fi
  fi

  local tag=$1
  local messages=("${@:2}")

  local bold_red="\e[1;31m"
  local end_color="\e[0m"
  echo -e "${bold_red}[$tag]$end_color ${messages[0]}"

  if [ "${#messages[@]}" -gt 1 ]; then
    local identation
    identation="$(printf " %.0s" $(seq 1 $((${#tag} + 2))))"

    local messages=("${messages[@]:1}")
    for message in "${messages[@]}"; do
      echo "$identation $message"
    done
  fi
}
