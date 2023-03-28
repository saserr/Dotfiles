import 'arguments::expect'

array::contains() {
  arguments::expect $# 'value' '[element]' '...'

  if (($# == 1)); then
    return 1
  fi

  local value=$1
  local elements=("${@:2}")

  local element
  for element in "${elements[@]}"; do
    if [[ "$value" == "$element" ]]; then
      return 0
    fi
  done

  return 1
}
