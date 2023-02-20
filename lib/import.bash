if ! declare -F 'import' >/dev/null 2>&1; then
  __import_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

  __import::abort() {
    if { declare -F 'arguments::expect' >/dev/null 2>&1 && arguments::expect $# 'message'; } || (($#)); then
      local messages=("$1")
      if ((${#BASH_SOURCE[@]} > 2)); then
        local file="${BASH_SOURCE[2]}"
        local line="${BASH_LINENO[1]}"
        messages+=("at $file (line: $line)")
      fi
    else
      local messages=("requires a message as an argument")
      if ((${#BASH_SOURCE[@]} > 1)); then
        local file="${BASH_SOURCE[1]}"
        local line="${BASH_LINENO[0]}"
        messages+=("at $file (line: $line)")
      fi
    fi

    if declare -F 'abort' >/dev/null 2>&1; then
      abort 'import' "${messages[@]}"
    elif declare -F 'log::error' >/dev/null 2>&1 >/dev/null 2>&1; then
      log::error 'import' "${messages[@]}" 1>&2
    else
      echo "[import] ${messages[0]}" 1>&2
      if ((${#messages[@]} > 1)); then
        local message
        local messages=("${messages[@]:1}")
        for message in "${messages[@]}"; do
          echo "         $message" 1>&2
        done
      fi
    fi

    exit 2
  }

  __import::not_loaded() {
    local caller="${FUNCNAME[1]}"

    echo "[$caller] is being loaded; do not call" 1>&2

    if ((${#BASH_SOURCE[@]} > 1)); then
      local identation
      identation="$(printf " %.0s" $(seq 1 $((${#caller} + 2))))"
      local file="${BASH_SOURCE[1]}"
      local line="${BASH_LINENO[0]}"
      echo "$identation at $file (line: $line)" 1>&2
    fi

    exit 2
  }

  import() {
    if declare -F 'arguments::expect' >/dev/null 2>&1; then
      arguments::expect $# 'function'
    elif (($# != 1)); then
      __import::abort "requires a function name as an argument"
    fi

    local function=$1
    if declare -F "$function" >/dev/null 2>&1; then
      return 0
    fi

    if ! eval "${function}() { __import::not_loaded; };"; then
      __import::abort "failed to load the '$function' function"
    fi

    local file
    file="$__import_dir/${function//:://}.bash"
    # shellcheck source=/dev/null
    if ! source "$file"; then
      __import::abort "can't load the '$function' function from $file"
    fi

    local declaration
    if ! declaration="$(declare -f "$function" 2>&1)" \
      || [[ "$declaration" == *'__import::not_loaded'* ]]; then
      __import::abort "the '$function' function is missing in $file"
    fi
  }

  import 'arguments::expect'
  import 'log::error'
  import 'abort'

  __import_dir="${LIB_DIR:-$__import_dir}"
fi
