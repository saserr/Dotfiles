#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'platform::name'
}

@test "returns 'mac' if the current platform is Darwin" {
  load '../helpers/mocks/stub.bash'

  stub uname '-s : echo "Darwin"'

  [[ "$(platform::name)" == 'mac' ]]

  unstub uname
}

@test "returns the result of platform::linux::os_release if the current platform is Linux" {
  if [[ "$(uname -s)" != 'Linux' ]]; then
    skip 'linux-only test'
  fi

  load '../helpers/mocks/stub.bash'

  mv /etc/os-release /etc/os-release.tmp
  echo "ID=foo" >/etc/os-release
  stub uname '-s : echo "Linux"'

  [[ "$(platform::name)" == 'foo' ]]

  unstub uname
  rm /etc/os-release
  mv /etc/os-release.tmp /etc/os-release
}
