import 'arguments::expect'
import 'platform::name'

case "$(platform::name)" in
  'mac')
    import 'abort'
    import 'command::exists'

    path::canonicalize() {
      arguments::expect $# 'path'

      local path=$1

      if command::exists 'greadlink'; then
        greadlink -f "$path"
      else
        abort platform_error 'mac' 'greadlink is not installed' 1>&2
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
