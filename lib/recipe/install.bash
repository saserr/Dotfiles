import 'platform::name'

case "$(platform::name)" in
  'mac')
    import 'mac::install'

    recipe::install() {
      mac::install
    }
    ;;
  'debian')
    import 'debian::install'

    recipe::install() {
      debian::install
    }
    ;;
  *)
    import 'arguments::expect'
    import 'log'
    import 'variable::expect'

    recipe::install() {
      arguments::expect $# # none
      variable::expect 'recipe'

      log::error "$(platform::name)" "don't know how to install ${recipe:?}"
      return 1
    }
    ;;
esac
