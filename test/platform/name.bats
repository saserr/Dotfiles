#!/usr/bin/env bats

setup() {
  source src/platform/name.bash
}

@test "returns 'mac' if the current platform is Darwin" {
  uname() { echo 'Darwin'; }

  [ "$(platform::name)" = 'mac' ]

  unset -f uname
}

@test "returns the result of platform::linux::os_release if the current platform is Linux" {
  # setup
  uname() { echo 'Linux'; }
  mv /etc/os-release /etc/os-release.tmp
  echo "ID=foo" >/etc/os-release

  [ "$(platform::name)" = 'foo' ]

  # cleanup
  unset -f uname
  rm /etc/os-release
  mv /etc/os-release.tmp /etc/os-release
}
