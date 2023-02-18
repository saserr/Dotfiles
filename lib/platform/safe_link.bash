import 'arguments::expect'
import 'log'
import 'path::exists'
import 'prompt::yes_or_no'

platform::safe_link() {
  arguments::expect $# 'name' 'from' 'to'

  local name=$1
  local from=$2
  local to=$3

  log::info "$name" "$to will be linked to $from"

  if ! path::exists "$from"; then
    log::error "$name" "$from does not exist; aborting!"
    return 1
  fi

  if path::exists "$to"; then
    if path::exists "$to.old"; then
      log::error "$name" "both $to and $to.old already exist; aborting!"
      return 1
    fi

    case "$(prompt::yes_or_no "$name" "$to exists; do you want to replace it?" 'Yes')" in
      Yes)
        log::info "$name" "old $to will be moved to $to.old"
        mv "$to" "$to.old"
        ;;
      *)
        log::info "$name" "$to will not be linked"
        return 1
        ;;
    esac
  fi

  ln -s "$from" "$to"
}
