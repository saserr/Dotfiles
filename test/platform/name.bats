#!/usr/bin/env bats

setup() {
  load '../setup.bash'
  import 'platform::name'
}

@test "returns 'mac' on the 'Darwin' platform" {
  load '../helpers/mocks/stub.bash'

  stub uname '-s : echo "Darwin"'

  run platform::name

  unstub uname
  [[ "$output" == 'mac' ]]
}

@test "returns ID from /etc/os-release on the 'Linux' platform" {
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

@test "returns 'Linux' if sourcing of /etc/os-release fails on the 'Linux' platform" {
  load '../helpers/mocks/stub.bash'

  # force loading of platform::name before source has been mocked
  platform::name >/dev/null

  stub uname '-s : echo "Linux"'
  source() {
    if [[ "$1" == '/etc/os-release' ]]; then
      return 1
    else
      echo 'source is mocked' 1>&2
      exit 1
    fi
  }

  run platform::name

  unstub uname
  [[ "$output" == 'Linux' ]]
}

@test "returns 'Linux' if /etc/os-release does not have ID on the 'Linux' platform" {
  load '../helpers/mocks/stub.bash'

  # force loading of platform::name before source has been mocked
  platform::name >/dev/null

  stub uname '-s : echo "Linux"'
  source() {
    if [[ "$1" != '/etc/os-release' ]]; then
      echo 'source is mocked' 1>&2
      exit 1
    fi
  }

  run platform::name

  unstub uname
  [[ "$output" == 'Linux' ]]
}
