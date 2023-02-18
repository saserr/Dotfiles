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
    declare -n array="$name"
    ((${#array[@]}))
  else
    declare -n variable="$name"
    [[ "$variable" ]]
  fi
}
