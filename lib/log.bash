# Do not import any other functions because the import function depens on log.

log::info() {
  # green
  log '0;32' "$@"
}

log::warn() {
  # bold yellow
  log '1;33' "$@"
}

log::error() {
  # bold red
  log '1;31' "$@"
}

log() {
  if { type -t 'arguments::expect' &>/dev/null && arguments::expect $# 'color' 'tag' 'message' '...'; } ||
    [ $# -gt 2 ]; then
    local wrong_usage=0
    local output='/dev/stdout'
    local color="\033[${1}m"
    local tag=$2
    local messages=("${@:3}")
  else
    local wrong_usage=1
    local output='/dev/stderr'
    local color='\033[1;31m' # bold red
    local tag='log'
    local messages=('requires color, tag and one or more messages as arguments')

    # check if we need to skip one of the log::{info, warn, error} functions
    # when logging the call location
    if [ ${#FUNCNAME[@]} -gt 1 ] && [[ "${FUNCNAME[1]}" == 'log::'* ]]; then
      local stack_position=2
    else
      local stack_position=1
    fi
    if [ ${#BASH_SOURCE[@]} -gt "$stack_position" ]; then
      local file="${BASH_SOURCE[$stack_position]}"
      local line="${BASH_LINENO[$((stack_position - 1))]}"
      messages+=("at $file (line: $line)")
    fi
  fi

  local end_color='\033[0m'
  echo -e "${color}[$tag]$end_color ${messages[0]}" 1>"$output"

  if [ "${#messages[@]}" -gt 1 ]; then
    local identation
    identation="$(printf " %.0s" $(seq 1 $((${#tag} + 2))))"

    local message
    local messages=("${messages[@]:1}")
    for message in "${messages[@]}"; do
      echo "$identation $message" 1>"$output"
    done
  fi

  if [ "$wrong_usage" -eq 1 ]; then
    exit 2
  fi
}
