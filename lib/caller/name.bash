import 'arguments::expect'

caller::name() {
  arguments::expect $# # none

  # find caller::name's caller
  local -i i=1
  while [[ "${FUNCNAME[$i]}" == 'caller::name' ]]; do
    i=$((i + 1))
  done

  # $caller is caller::name's caller
  local caller="${FUNCNAME[$i]}"
  i=$((i + 1))

  local -i size="${#FUNCNAME[@]}"
  # skip the last element of the FUNCNAME array which is 'main'
  size=$((size - 1))
  # find the first function that is different from $caller
  while ((i < size)); do
    if [[ "${FUNCNAME[$i]}" != "$caller" ]]; then
      echo "${FUNCNAME[$i]}"
      return
    fi
    i=$((i + 1))
  done

  # otherwise print the script's name
  echo "$0"
}
