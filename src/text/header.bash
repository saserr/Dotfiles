source src/text/repeat.bash
source src/value/empty.bash

text::header() {
  local message=$1
  local length=${#message}

  if value::empty "$message"; then
    echo '**********'
  else
    text::repeat $((length + 4)) '*'
    echo
    echo "* $message *"
    text::repeat $((length + 4)) '*'
    echo
  fi
}
