import 'platform::name'

case "$(platform::name)" in
  'mac')
    import 'arguments::expect'
    import 'mac::install'

    recipe::install() {
      arguments::expect $# # none

      mac::install
    }
    ;;
  'debian')
    import 'arguments::expect'
    import 'debian::install'

    recipe::install() {
      arguments::expect $# # none

      debian::install
    }
    ;;
  *)
    import 'arguments::expect'
    import 'log::error'
    import 'variable::expect'

    recipe::install() {
      arguments::expect $# # none
      variable::expect 'recipe'

      log::error "$(platform::name)" "don't know how to install ${recipe:?}"
      return 1
    }
    ;;
esac
