#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'setup::directory'
}

@test "returns \$HOME/.local/state/dotfiles if \$XDG_STATE_HOME is not declared" {
  run setup::directory

  ((status == 0))
  [[ "$output" == "$HOME/.local/state/dotfiles" ]]
}

@test "returns \$XDG_STATE_HOME/dotfiles if \$XDG_STATE_HOME is declared" {
  local XDG_STATE_HOME="$BATS_TEST_TMPDIR"

  run setup::directory

  ((status == 0))
  [[ "$output" == "$XDG_STATE_HOME/dotfiles" ]]
}
