#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'log::trace'
}

@test "uses no color" {
  run log::trace 'foo' 'bar'

  ((status == 0))
  [[ "$output" == "$(echo '[foo] bar')" ]]
}
