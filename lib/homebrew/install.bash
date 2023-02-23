import 'arguments::expect'
import 'homebrew::missing'
import 'log::error'
import 'log::trace'

homebrew::install() {
  arguments::expect $# 'formula' '...'

  local formulas=("$@")

  local installed=()
  local missing=()
  for formula in "${formulas[@]}"; do
    if homebrew::missing "$formula"; then
      missing+=("$formula")
    else
      installed+=("$formula")
    fi
  done

  if ((${#installed[@]})); then
    log::trace 'homebrew' "already installed: ${installed[*]}"
  fi

  if ((${#missing[@]} == 0)); then
    return 0
  fi

  log::trace 'homebrew' "installing: ${missing[*]}"
  if ! { brew update && brew install "${missing[@]}"; }; then
    log::error 'homebrew' "installation failed"
    return 1
  fi
}
