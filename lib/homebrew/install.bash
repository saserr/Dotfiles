import 'arguments::expect'
import 'message::error'
import 'message::info'

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
    message::info 'homebrew' "$name already installed ..."
    return 0
  fi

  message::info 'homebrew' "installing $name ..."

  if ! { brew update && brew install "$formula"; }; then
    message::error 'homebrew' "failed to install $name"
    return 1
  fi
}
