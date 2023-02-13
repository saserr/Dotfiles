# Do not depend on any other source files because all other files depend on this
# one.

if ! type -t 'import' &>/dev/null; then
  __import_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
  __lib_dir="${LIB_DIR:-$__import_dir}"

  __import::local() {
    if [ $# -ne 1 ]; then
      return 1
    fi

    local function=$1
    if type -t "$function" &>/dev/null; then
      return 0
    fi

    local file
    file="$__import_dir/${function//::/\/}.bash"
    # shellcheck source=/dev/null
    source "$file" >/dev/null 2>&1 && type -t "$function" &>/dev/null
  }

  if ! __import::local 'message::error'; then
    echo "[import] can't load the 'message::error' function" 1>&2
    exit 2
  fi

  if ! __import::local 'abort'; then
    message::error 'import' "can't load the 'abort' function" 1>&2
    exit 2
  fi

  if ! __import::local 'arguments::expect'; then
    abort 'import' "can't load the 'arguments::expect' function"
  fi

  __import::abort() {
    arguments::expect $# 'message'

    local tag='import'
    local messages=("$1")
    if [ ${#BASH_SOURCE[@]} -gt 2 ]; then
      local file="${BASH_SOURCE[2]}"
      local line="${BASH_LINENO[1]}"
      messages+=("at $file (line: $line)")
    fi

    abort "$tag" "${messages[@]}"
  }

  import() {
    arguments::expect $# 'function'

    local function=$1
    if type -t "$function" &>/dev/null; then
      return 0
    fi

    local file
    file="$__lib_dir/${function//::/\/}.bash"
    # shellcheck source=/dev/null
    if ! source "$file" >/dev/null 2>&1; then
      __import::abort "can't load the '$function' function from $file"
    fi

    if ! type -t "$function" &>/dev/null; then
      __import::abort "the '$function' function is missing in $file"
    fi
  }
fi
