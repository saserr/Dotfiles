homebrew::install() {
  local name=$1
  local formula=$2

  if [ "$#" -lt 2 ]; then
    echo "Usage: ${FUNCNAME[0]} NAME FORMULA"
    return 1
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
