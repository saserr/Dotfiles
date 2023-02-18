import 'arguments::integer'
import 'arguments::expect'

text::repeat() {
  arguments::expect $# 'times' 'text'
  arguments::integer 'first' "$1"

  local -i times=$1
  local text=$2

  if ((times > 0)); then
    printf "$text%.0s" $(seq 1 "$times")
  fi
}
