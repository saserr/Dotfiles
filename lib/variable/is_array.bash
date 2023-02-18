import 'arguments::expect'
import 'text::starts_with'

variable::is_array() {
  arguments::expect $# 'name'

  local name=$1
  local declaration
  declaration="$(declare -p "$name" 2>&1)" || return 1

  text::starts_with "$declaration" 'declare -a' \
    || text::starts_with "$declaration" 'declare -A'
}
