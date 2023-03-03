import 'platform::name'

case "$(platform::name)" in
  'mac')
    import 'arguments::expect'

    temporary::directory() {
      arguments::expect $# '[path]'

      if (($# == 1)); then
        local path=$1
        echo "$path/$(cd "$path" && mktemp -d 'tmp.XXXXXX')"
      else
        mktemp -d
      fi
    }
    ;;
  *)
    import 'arguments::expect'

    temporary::directory() {
      arguments::expect $# '[path]'

      if (($# == 1)); then
        local path=$1
        mktemp -d -p "$path"
      else
        mktemp -d
      fi
    }
    ;;
esac
