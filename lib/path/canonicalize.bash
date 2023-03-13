import 'arguments::expect'
import 'platform::name'

case "$(platform::name)" in
  'mac')
    import 'command::exists'
    import 'log::error'

    path::canonicalize() {
      arguments::expect $# 'path'

      local path=$1

      if command::exists 'greadlink'; then
        greadlink -f "$path"
      else
        log::error 'mac' 'greadlink is not installed' 1>&2
        exit 1
      fi
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
