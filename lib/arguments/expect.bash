# Do not import any other functions because the import function depens on
# arguments::expect.

__arguments::expect::abort() {
  # check if this function has the correct number of arguments
  if [ $# -lt 2 ]; then
    local -i stack_position=0
    local -i actual=$#
    local names=('stack_position' 'actual' '[name]' '...')
  else
    local -i stack_position=$(($1 + 1)) # add 1 to skip this function on the stack
    local -i actual=$2
    local names=("${@:3}")
  fi

  local function
  # skip the last element of the FUNCNAME array which is 'main'
  if [ $((stack_position + 1)) -lt ${#FUNCNAME[@]} ]; then
    function="${FUNCNAME[$stack_position]}"
  else
    function="$0"
  fi

  local messages=()
  local message='wrong number of arguments'
  if [ $((stack_position + 1)) -lt ${#BASH_SOURCE[@]} ]; then
    local file="${BASH_SOURCE[$((stack_position + 1))]}"
    local line="${BASH_LINENO[$stack_position]}"
    message+=" at $file (line: $line)"
  fi
  messages+=("$message")

  messages+=("actual: $actual")

  message='expected: '
  if [ "${vararg:?}" -ne 0 ]; then
    message+="${required:?} (or more)"
  elif [ "${optional:?}" -gt 0 ]; then
    if [ "${required:?}" -gt 0 ]; then
      message+="${required:?} (+ ${optional:?} optional)"
    else
      message+="${optional:?} optional"
    fi
  else
    message+="${required:?}"
  fi
  messages+=("$message")

  if [ ${#names[@]} -gt 0 ]; then
    messages+=("arguments: ${names[*]}")
  fi

  if type -t 'abort' &>/dev/null; then
    abort "$function" "${messages[@]}"
  else
    echo "[$function] ${messages[0]}" 1>&2
    messages=("${messages[@]:1}")
    local message
    for message in "${messages[@]}"; do
      echo "    $message" 1>&2
    done
    exit 2
  fi
}

arguments::expect() {
  local -i actual=$1

  # check if this function has the correct number of arguments and that the
  # first argument is an integer
  if [ $# -lt 1 ] || [ "$actual" != "$1" ]; then
    local -i vararg=1
    local -i optional=1
    local -i required=1
    __arguments::expect::abort 0 $# '$#' '[name]' '...'
  fi

  [ "$actual" -eq $(($# - 1)) ] && return 0

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

  if [ "$actual" -lt "$required" ] ||
    { [ "$vararg" -eq 0 ] && [ "$actual" -gt $((required + optional)) ]; }; then
    __arguments::expect::abort 1 "$actual" "${names[@]}"
  fi
}
