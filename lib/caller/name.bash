import 'arguments::expect'

caller::name() {
  arguments::expect $# # none

  # skip the last element of the FUNCNAME array which is 'main'
  if ((${#FUNCNAME[@]} > 3)); then
    echo "${FUNCNAME[2]}"
  else
    echo "$0"
  fi
}
