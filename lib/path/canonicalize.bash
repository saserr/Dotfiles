import 'arguments::expect'
import 'log'
import 'platform::name'

if ! platform="$(platform::name)"; then
  log error 'path::canonicalize' 'unable to determine the platform name'
  return 1
fi

case "$platform" in
  'mac')
    import 'command::exists'

    path::canonicalize() {
      arguments::expect $# 'path'

      if ! command::exists 'greadlink'; then
        log error 'mac' 'greadlink is not installed'
        return 1
      fi

      local path=$1

      greadlink -f "$path"
    }
    ;;
  *)
    path::canonicalize() {
      arguments::expect $# 'path'

      local path=$1

      readlink -f "$path"
    }
    ;;
esac
