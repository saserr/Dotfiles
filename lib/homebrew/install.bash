import 'arguments::expect'
import 'command::exists'
import 'homebrew::missing'
import 'log'

homebrew::install() {
  arguments::expect $# 'formula' '...'

  if ! command::exists 'brew'; then
    log error 'homebrew' 'is not installed' 1>&2
    exit 1
  fi

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
    log trace 'homebrew' "already installed: ${installed[*]}"
  fi

  if ((${#missing[@]} == 0)); then
    return 0
  fi

  log trace 'homebrew' "installing: ${missing[*]}"
  if ! { brew update && brew install "${missing[@]}"; }; then
    log error 'homebrew' "installation failed"
    return 1
  fi
}
