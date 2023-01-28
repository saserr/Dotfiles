# TODO name is optional

source src/arguments/expect.bash

homebrew::install() {
  arguments::expect $# 'name' 'formula'

  local name=$1
  local formula=$2

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
