import 'arguments::error'
import 'arguments::expect'
import 'log'

export question_log_color='0;34' # blue

prompt::question() {
  arguments::expect $# 'tag' 'message'

  local tag=$1
  local question=$2

  if ! { question="$(log question "$tag" "$question" 2>&1)" \
    && printf '%s' "$question" 1>&2; }; then
    log error "${FUNCNAME[0]}" 'failed to ask the question'
    return 1
  fi

  local answer
  if ! read -r answer; then
    log error "${FUNCNAME[0]}" 'failed to read the answer'
    return 1
  fi

  echo "$answer"
}
