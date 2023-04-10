import 'arguments::expect'
import 'abort'
import 'command::exists'
import 'homebrew::missing'
import 'log'

homebrew::install() {
  arguments::expect $# 'formula' '...'

  if ! command::exists 'brew'; then
    abort platform_error 'homebrew' 'is not installed'
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
  brew update && brew install "${missing[@]}"
  local -i status=$?

  if ((status)); then
    log error 'homebrew' "installation failed"
  fi

  return "$status"
}
