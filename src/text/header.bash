import 'arguments::expect'
import 'text::repeat'
import 'value::empty'

text::header() {
  arguments::expect $# '[title]'

  local title=$1
  local length=${#title}

  if value::empty "$title"; then
    echo '**********'
  else
    text::repeat $((length + 4)) '*'
    echo
    echo "* $title *"
    text::repeat $((length + 4)) '*'
    echo
  fi
}
