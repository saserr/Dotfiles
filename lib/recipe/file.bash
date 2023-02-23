import 'arguments::expect'
import 'bash::support::declare_global'
import 'file::exists'
import 'variable::expect'

if bash::support::declare_global; then
  declare -ga 'RECIPES_PATH'
elif ! variable::exists 'RECIPES_PATH'; then
  RECIPES_PATH=()
fi

RECIPES_PATH+=("recipes")

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
