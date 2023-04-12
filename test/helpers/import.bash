__current_dir="$(dirname -- "${BASH_SOURCE[0]}")" || return
__helpers_dir="$(cd -- "$__current_dir" >/dev/null && pwd)" || return
IMPORT_PATH+=("$__helpers_dir")
