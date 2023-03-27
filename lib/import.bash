if ! declare -F 'import' >/dev/null 2>&1; then
  IMPORT_PATH+=("$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)")

  __import::abort() {
    if (($#)); then
      local messages=("$1")
      if ((${#BASH_SOURCE[@]} > 2)); then
        local file="${BASH_SOURCE[2]}"
        local line="${BASH_LINENO[1]}"
        messages+=("at $file (line: $line)")
      fi
    else
      local messages=('expected argument: message')
      if ((${#BASH_SOURCE[@]} > 1)); then
        local file="${BASH_SOURCE[1]}"
        local line="${BASH_LINENO[0]}"
        messages+=("at $file (line: $line)")
      fi
    fi

    if declare -F 'abort' >/dev/null 2>&1; then
      abort 'import' "${messages[@]}"
    elif declare -F 'log::error' >/dev/null 2>&1; then
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
    local function="${FUNCNAME[1]}"
    echo "[$function] is being loaded; do not call" 1>&2

    if ((${#BASH_SOURCE[@]} > 2)); then
      local indentation
      if ! indentation="$(printf " %.0s" $(seq 1 $((${#function} + 2))))"; then
        indentation=' '
      fi

      local file="${BASH_SOURCE[2]}"
      local line="${BASH_LINENO[1]}"
      echo "$indentation at $file (line: $line)" 1>&2
    fi

    exit 2
  }

  import() {
    if (($# != 1)); then
      __import::abort 'expected argument: function'
    fi

    local function=$1
    if declare -F "$function" >/dev/null 2>&1; then
      return 0
    fi

    local path
    for path in "${IMPORT_PATH[@]}"; do
      local file="$path/${function//:://}.bash"
      if [[ -e "$file" ]] && [[ ! -d "$file" ]]; then
        # shellcheck source=/dev/null
        if ! { eval "$(printf '%q() { __import::not_loaded; };' "$function")" && source "$file"; }; then
          __import::abort "can't load the '$function' function from $file"
        fi

        local declaration
        if ! declaration="$(declare -f "$function" 2>&1)" \
          || [[ "$declaration" == *'__import::not_loaded'* ]]; then
          __import::abort "the '$function' function is missing in $file"
        fi

        return 0
      fi
    done

    __import::abort "unknown function: $function"
  }

  import 'log::error'
  import 'abort'
fi
