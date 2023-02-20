#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'log::warn'
}

@test "uses the bold yellow color" {
  run log::warn 'foo' 'bar'

  ((status == 0))
  [[ "$output" == "$(echo -e '\033[1;33m[foo]\033[0m bar')" ]]
}
