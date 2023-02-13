# Do not import any other functions because the import function depens on abort.

abort() {
  if { type -t 'arguments::expect' &>/dev/null && arguments::expect $# 'tag' 'message' '...'; } ||
    [ $# -gt 1 ]; then
    local tag=$1
    local messages=("${@:2}")
  else
    local tag='abort'
    local messages=('requires tag and one or more messages as arguments')
    if [ ${#BASH_SOURCE[@]} -gt 1 ]; then
      local file="${BASH_SOURCE[1]}"
      local line="${BASH_LINENO[0]}"
      messages+=("at $file (line: $line)")
    fi
  fi

  if type -t 'message::error' &>/dev/null; then
    message::error "$tag" "${messages[@]}" 1>&2
  else
    echo "[$tag] ${messages[0]}" 1>&2
    messages=("${messages[@]:1}")
    for message in "${messages[@]}"; do
      echo "    $message" 1>&2
    done
  fi

  exit 2
}
