#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'platform::name'
}

@test "returns 'mac' if the current platform is 'Darwin'" {
  load '../helpers/mocks/stub.bash'

  stub uname '-s : echo "Darwin"'

  [[ "$(platform::name)" == 'mac' ]]

  unstub uname
}

@test "returns ID from /etc/os-release if the current platform is 'Linux'" {
  load '../helpers/mocks/stub.bash'
  import 'abort'

  stub uname '-s : echo "Linux"'
  source() {
    if [[ "$1" == '/etc/os-release' ]]; then
      ID='foo'
    else
      abort 'source' 'is mocked'
    fi
  }

  [[ "$(platform::name)" == 'foo' ]]

  unstub uname
}
