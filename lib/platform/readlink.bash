import 'platform::name'

case "$(platform::name)" in
  'mac')
    import 'abort'
    import 'command::exists'

    platform::readlink() {
      if command::exists 'greadlink'; then
        greadlink "$@"
      else
        abort 'mac' 'greadlink is missing'
      fi
    }
    ;;
  *)
    platform::readlink() {
      readlink "$@"
    }
    ;;
esac
