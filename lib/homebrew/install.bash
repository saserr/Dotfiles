import 'arguments::expect'

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
    echo "[homebrew] $name already installed ..."
    return 0
  fi

  echo "[homebrew] installing $name ..."

  if ! { brew update && brew install "$formula"; }; then
    echo "[homebrew] failed to install $name"
    return 1
  fi
}
