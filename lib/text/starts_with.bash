import 'arguments::expect'

text::starts_with() {
  arguments::expect $# 'text' 'prefix'

  local text=$1
  local prefix=$2

  [[ "$text" == "$prefix"* ]]
}
