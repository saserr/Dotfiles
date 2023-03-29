import 'arguments::error'
import 'arguments::expect'
import 'log'

export question_log_color='0;34' # blue

prompt::question() {
  arguments::expect $# 'tag' 'message'

  local tag=$1
  local question=$2

  question="$(log question "$tag" "$question")" || return
  printf '%s' "$question" 1>&2 || return

  local answer
  read -r answer || return
  echo "$answer"
}
