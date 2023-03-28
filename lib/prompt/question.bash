import 'arguments::error'
import 'arguments::expect'
import 'log'

export question_log_color='0;34' # blue

prompt::question() {
  arguments::expect $# 'tag' 'message'

  local tag=$1
  local question=$2

  printf '%s' "$(log question "$tag" "$question")" 1>&2
  local answer
  read -r answer || return 1
  echo "$answer"
}
