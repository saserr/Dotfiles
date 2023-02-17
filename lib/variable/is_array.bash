import 'arguments::expect'

variable::is_array() {
  arguments::expect $# 'name'

  local name=$1

  local declaration
  declaration="$(declare -p "$name" 2>&1)" || return 1
  [[ "$declaration" == "declare -a"* ]] || [[ "$declaration" == "declare -A"* ]]
}
