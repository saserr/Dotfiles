import 'platform::name'

case "$(platform::name)" in
  'mac')
    import 'arguments::expect'

    temporary::directory() {
      arguments::expect $# '[path]'

      if (($# == 1)); then
        local path=$1

        local directory
        directory="$(cd "$path" && mktemp -d 'tmp.XXXXXXXX')" || return

        echo "$path/$directory"
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
