import 'arguments::expect'
import 'log'
import 'path::parent'
import 'setup::file'

setup::done() {
  arguments::expect $# 'recipe'

  local recipe=$1

  local file
  local directory
  if ! { file="$(setup::file "$recipe")" \
    && directory="$(path::parent "$file")" \
    && mkdir -p "$directory" \
    && echo '1' >"$file"; }; then
    log error "$recipe" 'failed to save the state file'
    return 1
  fi
}
