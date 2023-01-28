source src/arguments/expect.bash

platform::login_shell() {
  arguments::expect $# # none

  if echo "$SHELL" | grep -q zsh; then
    echo 'zsh'
  elif echo "$SHELL" | grep -q bash; then
    echo 'bash'
  else
    echo "$SHELL"
  fi
}
