import 'log'
import 'platform::name'

if ! platform="$(platform::name)"; then
  log error 'temporary::file' 'unable to determine the platform name'
  return 1
fi

case "$platform" in
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
