import 'arguments::expect'

command::exists() {
  arguments::expect $# 'name'

  local name=$1

  hash "$name" >/dev/null 2>&1
}
