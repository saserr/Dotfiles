import 'abort'

__arguments::expect::abort() {
  # check if this function has the correct number of arguments
  if (($# < 2)); then
    local -i stack_position=0
    local -i actual=$#
    local names=('stack_position' 'actual' '[name]' '...')
  else
    local -i stack_position=$(($1 + 1)) # add 1 to skip this function on the stack
    local -i actual=$2
    local names=("${@:3}")
  fi

  local messages=('wrong number of arguments' "actual: $actual")

  local message='expected: '
  if ((vararg)); then
    message+="${required:?} (or more)"
  elif ((optional)); then
    if ((required)); then
      message+="${required:?} (+ ${optional:?} optional)"
    else
      message+="${optional:?} optional"
    fi
  else
    message+="${required:?}"
  fi
  messages+=("$message")

  if ((${#names[@]})); then
    messages+=("arguments: ${names[*]}")
  fi

  if (((stack_position + 1) < ${#BASH_SOURCE[@]})); then
    local file="${BASH_SOURCE[$((stack_position + 1))]}"
    local line="${BASH_LINENO[$stack_position]}"
    messages+=("at $file (line: $line)")
  fi

  local function
  # skip the last element of the FUNCNAME array which is 'main'
  if ((stack_position < (${#FUNCNAME[@]} - 1))); then
    function="${FUNCNAME[$stack_position]}"
  else
    function="$0"
  fi

  abort "$function" "${messages[@]}"
}

arguments::expect() {
  # check if this function has the correct number of arguments
  if (($# < 1)); then
    local -i vararg=1
    local -i optional=1
    local -i required=1
    __arguments::expect::abort 0 $# '$#' '[name]' '...'
  fi

  local -i actual=$1
  # check if the first argument is an integer
  if [[ "$actual" != "$1" ]]; then
    local messages=('expected integer argument: $#' "actual: $1")
    if ((${#BASH_SOURCE[@]} > 1)); then
      local file="${BASH_SOURCE[1]}"
      local line="${BASH_LINENO[0]}"
      messages+=("at $file (line: $line)")
    fi
    abort "${FUNCNAME[0]}" "${messages[@]}"
  fi

  ((actual == ($# - 1))) && return 0

  local names=("${@:2}")

  # count number of required and optional arguments and if there is a vararg
  local -i vararg=0
  local -i optional=0
  local -i required=0
  local name
  for name in "${names[@]}"; do
    case $name in
      '...')
        vararg=1
        ;;
      '['*']')
        optional=$optional+1
        ;;
      *)
        required=$required+1
        ;;
    esac
  done

  if ((actual < required)) \
    || { ((vararg == 0)) && ((actual > (required + optional))); }; then
    __arguments::expect::abort 1 "$actual" "${names[@]}"
  fi
}
