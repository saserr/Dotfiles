import 'arguments::expect'
import 'variable::exists'
import 'variable::is_array'

variable::nonempty() {
  arguments::expect $# 'name'

  local name=$1

  if ! variable::exists "$name"; then
    return 1
  fi

  if variable::is_array "$name"; then
    # 'declare -n' requires bash version >= 4.3
    if (("${BASH_VERSINFO[0]}" > 4)) \
      || ((("${BASH_VERSINFO[0]}" == 4) && ("${BASH_VERSINFO[1]}" >= 3))); then
      # check if array has size > 0
      declare -n array="$name"
      ((${#array[@]}))
    elif (("${BASH_VERSINFO[0]}" < 4)); then
      # check if first element of the array is not null. note that this check
      # does not work with an associative array, hence it is not safe to use it
      # on bash versions >= 4.
      [[ -n "${!name[0]+declared}" ]]
    else # bash versions between [4, 4.2] (untested)
      eval "((\${#${name}[@]}))"
    fi
  else
    [[ "${!name}" ]]
  fi
}
