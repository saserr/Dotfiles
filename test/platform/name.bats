#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'platform::name'
}

@test "returns 'mac' if the current platform is 'Darwin'" {
  load '../helpers/mocks/stub.bash'

  stub uname '-s : echo "Darwin"'

  run platform::name

  unstub uname
  [[ "$output" == 'mac' ]]
}

@test "returns ID from /etc/os-release if the current platform is 'Linux'" {
  load '../helpers/mocks/stub.bash'

  # force loading of platform::name before source has been mocked
  platform::name >/dev/null

  stub uname '-s : echo "Linux"'
  source() {
    if [[ "$1" == '/etc/os-release' ]]; then
      ID='foo'
    else
      echo 'source is mocked' 1>&2
      exit 1
    fi
  }

  run platform::name

  unstub uname
  [[ "$output" == 'foo' ]]
}
