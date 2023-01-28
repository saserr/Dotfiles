import 'arguments::expect'

value::empty() {
  arguments::expect $# 'value'

  local value=$1

  [ -z "$value" ]
}
