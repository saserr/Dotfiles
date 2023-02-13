# Do not depend on any other source files because all other files depend on this
# one.

__arguments::expect::print_error() {
  # check if this function has the correct number of arguments
  if [ $# -lt 2 ]; then
    local stack_position=0
    local actual=$#
    local names=('stack_position' 'actual' '[name]' '...')
  else
    local stack_position=$(($1 + 1)) # add 1 to skip this function on the stack
    local actual=$2
    local names=("${@:3}")
  fi

  local function
  if [ "$stack_position" -lt ${#FUNCNAME[@]} ]; then
    function="${FUNCNAME[$stack_position]}"
  else
    function="$0"
  fi

  printf '[%s] wrong number of arguments' "$function"
  if [ $((stack_position + 1)) -lt ${#BASH_SOURCE[@]} ]; then
    local file="${BASH_SOURCE[$((stack_position + 1))]}"
    local line="${BASH_LINENO[$stack_position]}"
    printf ' at %s (line: %d)' "$file" "$line"
  fi
  echo

  local padding
  padding="$(printf " %.0s" $(seq 1 $((${#function} + 2))))"

  echo "$padding actual: $actual"

  printf '%s expected: ' "$padding"
  if [ "${vararg:?}" -ne 0 ]; then
    printf '%d (or more)' "${required:?}"
  elif [ "${optional:?}" -gt 0 ]; then
    if [ "${required:?}" -gt 0 ]; then
      printf '%d (+ %d optional)' "${required:?}" "${optional:?}"
    else
      printf '%d optional' "${optional:?}"
    fi
  else
    printf '%d' "${required:?}"
  fi
  echo

  if [ ${#names[@]} -gt 0 ]; then
    echo "$padding arguments: ${names[*]}"
  fi
}

arguments::expect() {
  # check if this function has the correct number of arguments
  if [ $# -lt 1 ]; then
    local vararg=1
    local optional=1
    local required=1
    __arguments::expect::print_error 0 $# '$#' '[name]' '...' 1>&2
    exit 2
  fi

  [ "$1" -eq $(($# - 1)) ] && return 0

  local actual=$1
  local names=("${@:2}")

  # count number of required and optional arguments and if there is a vararg
  local vararg=0
  local optional=0
  local required=0
  local name=''
  for name in "${names[@]}"; do
    case $name in
    '...')
      vararg=1
      ;;
    '['*)
      optional=$((optional + 1))
      ;;
    *)
      required=$((required + 1))
      ;;
    esac
  done

  if [ "$actual" -lt "$required" ] ||
    { [ "$vararg" -eq 0 ] && [ "$actual" -gt $((required + optional)) ]; }; then
    __arguments::expect::print_error 1 "$actual" "${names[@]}" 1>&2
    exit 2
  fi
}
