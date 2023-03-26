import 'arguments::error'
import 'arguments::expect'
import 'value::empty'

log() {
  arguments::expect $# 'color' 'tag' 'message' '...'

  local tag=$2
  if value::empty "$tag"; then
    arguments::error 'expected nonempty argument: tag'
  fi

  local messages=("${@:3}")
  if value::empty "${messages[0]}"; then
    arguments::error 'expected nonempty argument: message'
  fi

  if [[ "$1" ]]; then
    local color="\033[${1}m"
    local end_color='\033[0m'
    echo -e "${color}[$tag]$end_color ${messages[0]}"
  else
    echo "[$tag] ${messages[0]}"
  fi

  if ((${#messages[@]} > 1)); then
    local indentation
    if ! indentation="$(printf " %.0s" $(seq 1 $((${#tag} + 2))))"; then
      indentation=' '
    fi

    local message
    local messages=("${messages[@]:1}")
    for message in "${messages[@]}"; do
      if ! value::empty "$message"; then
        echo "$indentation $message"
      fi
    done
  fi
}
