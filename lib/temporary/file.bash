import 'platform::name'

case "$(platform::name)" in
  'mac')
    import 'arguments::expect'

    temporary::file() {
      arguments::expect $# '[path]'

      if (($# == 1)); then
        local path=$1

        local file
        file="$(cd "$path" && mktemp 'tmp.XXXXXXXX')" || return

        echo "$path/$file"
      else
        mktemp
      fi
    }
    ;;
  *)
    import 'arguments::expect'

    temporary::file() {
      arguments::expect $# '[path]'

      if (($# == 1)); then
        local path=$1
        mktemp -p "$path"
      else
        mktemp
      fi
    }
    ;;
esac
