import 'arguments::expect'

function::exists() {
  arguments::expect $# 'name'

  local name=$1

  declare -F "$name" >/dev/null 2>&1
}
