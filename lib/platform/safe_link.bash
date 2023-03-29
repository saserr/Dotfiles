import 'arguments::expect'
import 'log'
import 'path::canonicalize'
import 'path::exists'
import 'prompt::yes_or_no'

platform::safe_link() {
  arguments::expect $# 'name' 'from' 'to'

  local name=$1
  local from=$2
  local to=$3

  if ! path::exists "$to"; then
    log error "$name" "$to does not exist; aborting!"
    return 1
  fi

  local real_from
  local real_to
  if real_from="$(path::canonicalize "$from")" \
    && real_to="$(path::canonicalize "$to")" \
    && [[ "$real_from" == "$real_to" ]]; then
    log trace "$name" "$from already links to $to"
    return 0
  fi

  log trace "$name" "$from will be linked to $to"

  if path::exists "$from"; then
    if path::exists "$from.old"; then
      log error "$name" "both $from and $from.old already exist; aborting!"
      return 1
    fi

    case "$(prompt::yes_or_no "$name" "$from exists; do you want to replace it?" 'Yes')" in
      Yes)
        log trace "$name" "$from will be moved to $from.old"
        mv "$from" "$from.old" || return
        ;;
      *)
        log warn "$name" "$from will not be linked to $to"
        return 1
        ;;
    esac
  fi

  ln -s "$to" "$from"
}
