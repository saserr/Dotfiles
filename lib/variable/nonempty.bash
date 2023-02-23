import 'arguments::expect'
import 'bash::support::associative_array'
import 'bash::support::declare_reference'
import 'variable::exists'
import 'variable::is_array'

variable::nonempty() {
  arguments::expect $# 'name'

  local name=$1

  if ! variable::exists "$name"; then
    return 1
  fi

  if variable::is_array "$name"; then
    if bash::support::declare_reference; then
      # check if array has size > 0
      declare -n array="$name"
      ((${#array[@]}))
    elif bash::support::associative_array; then
      # check if array has size > 0
      eval "((\${#${name}[@]}))"
    else
      # check if first element of the array is not null. note that this check
      # does not work with an associative array, hence it is not safe to use it
      # on bash versions >= 4.
      [[ -n "${!name[0]+declared}" ]]
    fi
  else
    [[ "${!name}" ]]
  fi
}
