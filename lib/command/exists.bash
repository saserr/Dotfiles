import 'arguments::expect'

command::exists() {
  arguments::expect $# 'name'

  local name=$1

  hash "$name" 2>|/dev/null
}
