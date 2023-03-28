import 'arguments::expect'

value::integer() {
  arguments::expect $# 'value'

  local -i value="$1"

  [[ "$value" == "$1" ]]
}
