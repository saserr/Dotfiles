# Do not depend on any other source files because all other files depend on this
# one.

if ! type 'import' &>/dev/null; then
  __import_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
  __lib_dir="${LIB_DIR:-$__import_dir}"

  import() {
    if ! type 'arguments::expect' &>/dev/null; then
      # shellcheck source=/dev/null
      source "$__import_dir/arguments/expect.bash" >/dev/null 2>&1
    fi

    if type 'arguments::expect' &>/dev/null; then
      arguments::expect $# 'function'
    else
      if [ $# -ne 1 ]; then
        echo 'The function name in import is missing' 1>&2
        exit 2
      fi
    fi

    local name=$1

    if ! type "$name" &>/dev/null; then
      local file
      file="$__lib_dir/${name//::/\/}.bash"

      # shellcheck source=/dev/null
      if ! source "$file" >/dev/null 2>&1; then
        echo "Can't load '$name' at $file" 1>&2
        exit 2
      fi

      if [ "$(type -t "$name")" != 'function' ]; then
        echo "Missing '$name' at $file" 1>&2
        exit 2
      fi
    fi
  }
fi
