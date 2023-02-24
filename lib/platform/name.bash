import 'arguments::expect'

platform::name() {
  arguments::expect $# # none

  local os_name
  os_name="$(uname -s)"

  case $os_name in
    'Darwin')
      echo 'mac'
      ;;
    'Linux')
      # shellcheck source=/dev/null
      printf '%s\n' "$(source '/etc/os-release' && echo "$ID")"
      ;;
    *)
      echo "$os_name"
      ;;
  esac
}
