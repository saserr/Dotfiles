#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'platform::is_root'
}

@test "succeeds if the current user is root" {
  load '../helpers/mocks/stub.bash'

  stub id '-u : echo 0'

  run platform::is_root

  unstub id
  ((status == 0))
  [[ "$output" == '' ]]
}

@test "fails if the current user is not root" {
  load '../helpers/mocks/stub.bash'

  stub id '-u : echo 1000'

  run platform::is_root

  unstub id
  ((status == 1))
  [[ "$output" == '' ]]
}

@test "fails if printing the effective user ID fails" {
  load '../helpers/import.bash'
  load '../helpers/mocks/stub.bash'
  import 'assert::exits'
  import 'capture::stderr'
  import 'log'

  stub id '-u : exit 1'

  assert::exits platform::is_root

  unstub id
  ((status == 2))
  [[ "$output" == "$(capture::stderr log error 'id' 'command failed')" ]]
}
