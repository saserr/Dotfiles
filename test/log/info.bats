#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'log::info'
}

@test "uses the green color" {
  run log::info 'foo' 'bar'

  ((status == 0))
  [[ "$output" == "$(echo -e '\033[0;32m[foo]\033[0m bar')" ]]
}
