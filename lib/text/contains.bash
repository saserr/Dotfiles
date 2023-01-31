import 'arguments::expect'

text::contains() {
  arguments::expect $# 'text' 'infix'

  local text=$1
  local infix=$2

  [[ "$text" == *"$infix"* ]]
}
