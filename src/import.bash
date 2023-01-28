# Do not depend on any other source files because all other files depend on this
# one.

if ! type 'import' &>/dev/null; then
  __import_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

  import() {
    local name=$1

    if ! type "$name" &>/dev/null; then
      local file
      file="$__import_dir/${name//::/\/}.bash"

      # shellcheck source=/dev/null
      if ! source "$file"; then
        echo "Can't load '$1' at $file" 1>&2
        exit 2
      fi
    fi
  }
fi
