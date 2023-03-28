import 'abort::exit'
import 'caller::name'
import 'log'
import 'stack_trace::create'

__arguments::expect::abort() {
  # check if this function has the correct number of arguments
  if (($# < 3)); then
    local function="${FUNCNAME[0]}"
    local -i stack_position=0
    local -i actual=$#
    local names=('stack_position' 'actual' '[name]' '...')
  else
    local function=$1
    local -i stack_position=$(($2 + 1)) # add 1 to skip this function on the stack
    local -i actual=$3
    local names=("${@:4}")
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

  # add stack trace
  if stack_trace::create; then
    # skip all elements on STACK_TRACE up to stack_position's caller
    messages+=("${STACK_TRACE[@]:$((stack_position + 1))}")
  fi

  log error "$function" "${messages[@]}"
  abort::exit internal_error
}

arguments::expect() {
  # check if this function has the correct number of arguments
  if (($# < 1)); then
    local -i vararg=1
    local -i optional=1
    local -i required=1
    __arguments::expect::abort "${FUNCNAME[0]}" 0 $# '$#' '[name]' '...'
  fi

  local -i actual=$1
  # check if the first argument is an integer
  if [[ "$actual" != "$1" ]]; then
    local messages=('expected integer argument: $#' "actual: $1")
    # add stack trace
    if import 'stack_trace::create' && stack_trace::create; then
      # skip ${STACK_TRACE[0]} which is this file (expect.bash)
      messages+=("${STACK_TRACE[@]:1}")
    fi

    log error "${FUNCNAME[0]}" "${messages[@]}"
    abort::exit internal_error
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
    __arguments::expect::abort "$(caller::name)" 1 "$actual" "${names[@]}"
  fi
}
