import 'arguments::error'
import 'arguments::expect'
import 'log'

prompt::question() {
  arguments::expect $# 'tag' 'message'

  local tag=$1
  local question=$2

  printf '%s' "$(log '0;34' "$tag" "$question")" 1>&2
  local answer
  read -r answer || return 1
  echo "$answer"
}
