import 'arguments::expect'
import 'log'
import 'file::exists'
import 'variable::expect'

recipe::file() {
  arguments::expect $# # none
  variable::expect 'recipe'

  echo "${recipe:?}/recipe"
}
