import 'arguments::expect'
import 'variable::expect'

recipe::file() {
  arguments::expect $# # none
  variable::expect 'recipe'

  echo "recipes/${recipe:?}/recipe.bash"
}
