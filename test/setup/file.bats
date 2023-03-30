#!/usr/bin/env bats

setup() {
  load '../setup.bash'
  import 'setup::file'
}

@test "fails without arguments" {
  load '../helpers/import.bash'
  import 'assert::wrong_usage'

  run setup::file

  assert::wrong_usage 'setup::file' 'recipe'
}

@test "returns \$HOME/.local/state/dotfiles/\$recipe if \$XDG_STATE_HOME is not declared" {
  run setup::file 'foo'

  ((status == 0))
  [[ "$output" == "$HOME/.local/state/dotfiles/foo" ]]
}

@test "returns \$XDG_STATE_HOME/dotfiles/\$recipe if \$XDG_STATE_HOME is declared" {
  local XDG_STATE_HOME="$BATS_TEST_TMPDIR"

  run setup::file 'foo'

  ((status == 0))
  [[ "$output" == "$XDG_STATE_HOME/dotfiles/foo" ]]
}
