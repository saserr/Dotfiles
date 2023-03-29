if ! declare -F 'import' >/dev/null 2>&1; then
  IMPORT_PATH+=("$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)")
  SKIP_ON_STACK_TRACE+=("${BASH_SOURCE[0]}")

  __import::abort() {
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

  __import::not_loaded() {
    local function="${FUNCNAME[1]}"

    # if the function that is being loaded is used by __import::abort, unset it
    # so that this function is not again called which would lead to a call cycle
    if [[ "$function" == 'abort' ]] || [[ "$function" == 'log' ]]; then
      unset -f "$function"
    fi

    __import::abort "$function" 'is being loaded; do not call'
  }

  __import::load() {
    local function="${FUNCNAME[1]}"
    local file=$1

    local declaration
    # shellcheck source=/dev/null
    if ! { printf -v declaration '%q() { __import::not_loaded; };' "$function" \
      && eval "$declaration" \
      && source "$file"; }; then
      __import::abort 'import' "can't load the '$function' function from $file"
    fi

    if ! declaration="$(declare -f "$function" 2>&1)" \
      || [[ "$declaration" == *'__import::not_loaded'* ]]; then
      __import::abort 'import' "the '$function' function is missing in $file"
    fi
  }

  import() {
    if (($# != 1)); then
      __import::abort 'import' 'expected argument: function'
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
        if ! { printf -v declaration '%q() { __import::load '\''%q'\''; %q "$@"; };' "$function" "$file" "$function" \
          && eval "$declaration"; }; then
          __import::abort "can't declare the '$function' function"
        fi
        return 0
      fi
    done

    __import::abort 'import' "unknown function: $function"
  }

  import 'log'
  import 'abort'
fi
