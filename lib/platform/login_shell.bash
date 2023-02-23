import 'arguments::expect'

platform::login_shell() {
  arguments::expect $# # none

  if [[ "$SHELL" == *'/zsh' ]]; then
    echo 'zsh'
  elif [[ "$SHELL" == *'/bash' ]]; then
    echo 'bash'
  else
    echo "$SHELL"
  fi
}
