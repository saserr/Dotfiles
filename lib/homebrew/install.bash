import 'arguments::expect'
import 'log'

homebrew::install() {
  arguments::expect $# '[name]' 'formula' '...'

  if (($# == 1)); then
    local name=$1
    local formulas=("$1")
  else
    local name=$1
    local formulas=("${@:2}")
  fi

  local missing=()
  for formula in "${formulas[@]}"; do
    if homebrew::missing "$formula"; then
      missing+=("$formula")
    fi
  done

  if ((${#missing[@]} == 0)); then
    log::info 'homebrew' "$name already installed ..."
    return 0
  fi

  log::info 'homebrew' "installing $name ..."

  if ! { brew update && brew install "${missing[@]}"; }; then
    log::error 'homebrew' "failed to install $name"
    return 1
  fi
}
