import 'platform::name'

# TODO test

case "$(platform::name)" in
  'mac')
    platform::readlink() {
      greadlink "$@"
    }
    ;;
  *)
    platform::readlink() {
      readlink "$@"
    }
    ;;
esac
