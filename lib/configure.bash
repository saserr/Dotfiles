# TODO tests

SKIP_ON_STACK_TRACE+=()
ABORT_WITH_STACK_TRACE+=('internal_error')

__abort() {
  if (($# > 1)); then
    local tag=$1
    local messages=("${@:2}")
  else
    local tag="${FUNCNAME[0]}"
    local messages=('expected argument: tag message ...')
  fi

  if declare -F 'abort' >/dev/null 2>&1; then
    abort internal_error "$tag" "${messages[@]}"
  else
    # add stack trace
    if import 'stack_trace::create' && stack_trace::create; then
      messages+=("${STACK_TRACE[@]}")
    fi

    if declare -F 'log' >/dev/null 2>&1; then
      log error "$tag" "${messages[@]}" 1>&2
    else
      echo "[$tag] ${messages[0]}" 1>&2
      if ((${#messages[@]} > 1)); then
        local indentation
        if ! printf -v indentation ' %.0s' $(seq 1 $((${#tag} + 2))); then
          indentation=' '
        fi

        local message
        local messages=("${messages[@]:1}")
        for message in "${messages[@]}"; do
          echo "$indentation $message" 1>&2
        done
      fi
    fi

    exit 3
  fi
}

if [[ ! "$RUNTIME_DIR" ]]; then
  __runtime_dir="${XDG_RUNTIME_DIR:-${TMPDIR:-/tmp}}/dotfiles"
  if ! mkdir -p "$__runtime_dir"; then
    __abort 'dotfiles' 'failed to create the runtime directory'
  fi
  if ! RUNTIME_DIR="$(mktemp -d "$__runtime_dir/run.XXXXXXXXXX")"; then
    __abort 'configure' 'failed to create the runtime directory'
  fi
  export RUNTIME_DIR
fi

if ! __current_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"; then
  __abort 'configure' 'failed to determine the parent directory'
fi

IMPORT_PATH+=("$__current_dir")

# shellcheck source=/dev/null
if ! source "$__current_dir/import.bash"; then
  __abort 'configure' 'failed'
fi

import 'log'
import 'abort'
