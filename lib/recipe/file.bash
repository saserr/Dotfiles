import 'arguments::expect'
import 'file::exists'
import 'variable::expect'

RECIPES_PATH+=("$PWD/recipes")

recipe::file() {
  arguments::expect $# # none
  variable::expect 'recipe'

  local path
  for path in "${RECIPES_PATH[@]}"; do
    local file="$path/${recipe:?}/recipe.bash"
    if file::exists "$file"; then
      echo "$file"
      return 0
    fi
  done

  return 1
}
