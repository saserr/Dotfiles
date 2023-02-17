import 'arguments::expect'

variable::exists() {
  arguments::expect $# 'name'

  local name=$1

  declare -p "$name" &>/dev/null
}
