import 'arguments::expect'
import 'log'

homebrew::install() {
  arguments::expect $# '[name]' 'formula'

  if [ $# -eq 1 ]; then
    local name=$1
    local formula=$1
  else
    local name=$1
    local formula=$2
  fi

  if [ "$(brew list "$formula")" ]; then
    log::info 'homebrew' "$name already installed ..."
    return 0
  fi

  log::info 'homebrew' "installing $name ..."

  if ! { brew update && brew install "$formula"; }; then
    log::error 'homebrew' "failed to install $name"
    return 1
  fi
}
