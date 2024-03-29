import 'arguments::error'
import 'arguments::expect'
import 'prompt::question'
import 'value::empty'

prompt::yes_or_no() {
  arguments::expect $# 'tag' 'question' '[default: Yes|No]'

  local tag=$1
  local question=$2
  local default=''

  if (($# == 2)); then
    question="$question [y/n] "
  else
    case $3 in
      Yes)
        question="$question [Y/n] "
        default='Yes'
        ;;
      No)
        question="$question [y/N] "
        default='No'
        ;;
      *)
        arguments::error 'wrong default value' "actual: $3" 'expected: Yes|No'
        ;;
    esac
  fi

  while true; do
    local answer
    answer="$(prompt::question "$tag" "$question")" || return
    case "$answer" in
      [yY] | [yY][eE][sS])
        echo 'Yes'
        break
        ;;
      [nN] | [nN][oO])
        echo 'No'
        break
        ;;
      '')
        if ! value::empty "$default"; then
          echo "$default"
          break
        fi
        ;;
    esac
  done
}
