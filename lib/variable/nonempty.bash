import 'arguments::expect'
import 'array::exists'
import 'bash::support::associative_array'
import 'bash::support::declare_reference'
import 'variable::exists'

variable::nonempty() {
  arguments::expect $# 'name'

  local name=$1

  if ! variable::exists "$name"; then
    return 1
  fi

  if array::exists "$name"; then
    if bash::support::declare_reference; then
      declare -n array="$name"
      ((${#array[@]})) # check if array has size > 0
    elif bash::support::associative_array; then
      local test
      # shellcheck disable=SC2016
      # ignore the expansion in the first argument of printf because it is
      # meant for the eval function
      printf -v test '((${#%q[@]}))' "$name" # check if array has size > 0
      eval "$test"
    else
      # check if first element of the array is not null. note that this check
      # does not work with an associative array, hence it is not safe to use it
      # on bash versions >= 4.
      [[ "${!name[0]+declared}" ]]
    fi
  else
    [[ "${!name}" ]]
  fi
}
