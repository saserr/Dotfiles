# Do not depend on any other source files because all other files depend on this
# one.

if ! type 'import' &>/dev/null; then
  __import_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
  __lib_dir="${LIB_DIR:-$__import_dir}"

  # shellcheck source=/dev/null
  if ! source "$__import_dir/arguments/expect.bash" >/dev/null 2>&1 ||
    [ "$(type -t 'arguments::expect')" != 'function' ]; then
    echo "[import] can't load the 'arguments:expect' function" 1>&2
    exit 2
  fi

  import() {
    arguments::expect $# 'function'

    local name=$1

    if ! type -t "$name" &>/dev/null; then
      local file
      file="$__lib_dir/${name//::/\/}.bash"

      # shellcheck source=/dev/null
      if ! source "$file" >/dev/null 2>&1; then
        echo "[import] can't load the '$name' function from $file" 1>&2
        exit 2
      fi

      if [ "$(type -t "$name")" != 'function' ]; then
        echo "[import] the '$name' function is missing in $file" 1>&2
        exit 2
      fi
    fi
  }
fi
