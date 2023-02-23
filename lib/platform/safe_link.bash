import 'arguments::expect'
import 'log::error'
import 'log::trace'
import 'path::exists'
import 'platform::readlink'
import 'prompt::yes_or_no'

platform::safe_link() {
  arguments::expect $# 'name' 'from' 'to'

  local name=$1
  local from=$2
  local to=$3

  if ! path::exists "$from"; then
    log::error "$name" "$from does not exist; aborting!"
    return 1
  fi

  if [[ "$(platform::readlink -f "$to")" == "$(platform::readlink -f "$from")" ]]; then
    log::trace "$name" "$to already links to $from"
    return 0
  fi

  log::trace "$name" "$to will be linked to $from"

  if path::exists "$to"; then
    if path::exists "$to.old"; then
      log::error "$name" "both $to and $to.old already exist; aborting!"
      return 1
    fi

    case "$(prompt::yes_or_no "$name" "$to exists; do you want to replace it?" 'Yes')" in
      Yes)
        log::trace "$name" "old $to will be moved to $to.old"
        mv "$to" "$to.old"
        ;;
      *)
        log::trace "$name" "$to will not be linked"
        return 1
        ;;
    esac
  fi

  ln -s "$from" "$to"
}
