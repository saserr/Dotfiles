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
    log error "$name" "$to does not exist" 'aborting!'
    return 1
  fi

  local real_from
  if ! real_from="$(path::canonicalize "$from")"; then
    log error "$name" "unable to cannonicalize path: $from" 'aborting!'
    return 1
  fi

  local real_to
  if ! real_to="$(path::canonicalize "$to")"; then
    log error "$name" "unable to cannonicalize path: $to" 'aborting!'
    return 1
  fi

  if [[ "$real_from" == "$real_to" ]]; then
    log trace "$name" "$from already links to $to"
    return 0
  fi

  log trace "$name" "$from will be linked to $to"

  if path::exists "$from"; then
    if path::exists "$from.old"; then
      log error "$name" "both $from and $from.old already exist" 'aborting!'
      return 1
    fi

    local answer
    if ! answer="$(prompt::yes_or_no "$name" "$from exists; do you want to replace it?" 'Yes')"; then
      log error "$name" "$from exists" "it will not be linked to $to"
      return 1
    fi

    case "$answer" in
      Yes)
        log trace "$name" "$from will be moved to $from.old"
        if ! mv "$from" "$from.old"; then
          log error "$name" "failed to move $from to $from.old"
          return 1
        fi
        ;;
      *)
        log warn "$name" "$from will not be linked to $to"
        return 1
        ;;
    esac
  fi

  ln -s "$to" "$from"
}
