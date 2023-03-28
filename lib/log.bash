import 'arguments::error'
import 'arguments::expect'
import 'value::empty'
import 'variable::exists'
import 'variable::nonempty'

export trace_log_color=''     # none
export info_log_color='0;32'  # green
export warn_log_color='1;33'  # bold yellow
export error_log_color='1;31' # bold red

log() {
  arguments::expect $# 'level' 'tag' 'message' '...'

  local level=$1
  if value::empty "$level"; then
    log warn 'log' "expected nonempty argument: level"
    level='trace'
  fi

  local tag=$2
  if value::empty "$tag"; then
    arguments::error 'expected nonempty argument: tag'
  fi

  local messages=("${@:3}")
  if value::empty "${messages[0]}"; then
    arguments::error 'expected nonempty argument: message'
  fi

  local color_variable_name="${level}_log_color"
  if variable::exists "$color_variable_name"; then
    if variable::nonempty "$color_variable_name"; then
      local color="${!color_variable_name}"
      echo -e "\033[${color}m[$tag]\033[0m ${messages[0]}"
    else
      echo "[$tag] ${messages[0]}"
    fi
  else
    log warn 'log' "expected variable: \$$color_variable_name"
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
