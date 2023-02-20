#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'log::error'
}

@test "uses the bold red color" {
  run log::error 'foo' 'bar'

  ((status == 0))
  [[ "$output" == "$(echo -e '\033[1;31m[foo]\033[0m bar')" ]]
}
