import 'arguments::expect'
import 'path::exists'
import 'prompt::yes_or_no'

platform::safe_link() {
  arguments::expect $# 'name' 'from' 'to'

  local name=$1
  local from=$2
  local to=$3

  echo "[$name] $to will be linked to $from"

  if ! path::exists "$from"; then
    echo "[$name] $from does not exist; aborting!"
    return 1
  fi

  if path::exists "$to"; then
    if path::exists "$to.old"; then
      echo "[$name] both $to and $to.old already exist; aborting!"
      return 1
    fi

    echo "[$name] $to exists; do you want to replace it (Yes / No)?"
    # shellcheck disable=SC2119
    case $(prompt::yes_or_no) in
    Yes)
      echo "[$name] old $to will be moved to $to.old"
      mv "$to" "$to.old"
      ;;
    No)
      echo "[$name] $to will not be linked"
      return 1
      ;;
    esac
  fi

  ln -s "$from" "$to"
}
