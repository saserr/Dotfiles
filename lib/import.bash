if ! declare -F 'import' >/dev/null 2>&1; then
  SKIP_ON_STACK_TRACE+=("${BASH_SOURCE[0]}")

  __import::not_loaded() {
    local function="${FUNCNAME[1]}"

    # if the function that is being loaded is used by __abort, unset it that
    # this function is not again called which would lead to a call cycle.
    if [[ "$function" == 'abort' ]] || [[ "$function" == 'log' ]]; then
      unset -f "$function"
    fi

    __abort "$function" 'is being loaded; do not call'
  }

  __import::load() {
    local function=$1
    local file=$2

    local declaration
    # shellcheck source=/dev/null
    if ! { printf -v declaration '%q() { __import::not_loaded; };' "$function" \
      && eval "$declaration" \
      && source "$file"; }; then
      __abort 'import' "can't load the $function function from $file"
    fi

    if ! declaration="$(declare -f "$function" 2>&1)" \
      || [[ "$declaration" == *'__import::not_loaded'* ]]; then
      __abort 'import' "the $function function is missing in $file"
    fi
  }

  import() {
    if (($# != 1)); then
      __abort 'import' 'expected arguments: [--eager] function'
    fi

    local function=$1
    if declare -F "$function" >/dev/null 2>&1; then
      return 0
    fi

    local path
    for path in "${IMPORT_PATH[@]}"; do
      local file="$path/${function//:://}.bash"
      if [[ -e "$file" ]] && [[ ! -d "$file" ]]; then
        local declaration
        if ! { printf -v declaration '%q() { __import::load '\''%q'\'' '\''%q'\''; %q "$@"; };' "$function" "$function" "$file" "$function" \
          && eval "$declaration"; }; then
          __abort "can't declare the $function function"
        fi
        return 0
      fi
    done

    __abort 'import' "unknown function: $function"
  }
fi
