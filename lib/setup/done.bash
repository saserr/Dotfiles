import 'arguments::expect'

setup::done() {
  arguments::expect $# 'recipe'

  local recipe=$1

  mkdir -p ~/.setup/
  echo "1" >"$HOME/.setup/$recipe"
}
