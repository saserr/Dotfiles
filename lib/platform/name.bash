import 'abort'
import 'arguments::expect'

platform::name() {
  arguments::expect $# # none

  local os_name
  if ! os_name="$(uname -s)"; then
    abort platform_error 'uname' 'command failed'
  fi

  case $os_name in
    'Darwin')
      echo 'mac'
      ;;
    'Linux')
      local id
      # shellcheck source=/dev/null
      if id="$(source '/etc/os-release' && echo "${ID:-$os_name}")"; then
        echo "$id"
      else
        echo "$os_name"
      fi
      ;;
    *)
      echo "$os_name"
      ;;
  esac
}
