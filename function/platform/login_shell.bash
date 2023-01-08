platform::login_shell() {
  if echo "$SHELL" | grep -q zsh; then
    echo 'zsh'
  elif echo "$SHELL" | grep -q bash; then
    echo 'bash'
  else
    echo "$SHELL"
  fi
}
