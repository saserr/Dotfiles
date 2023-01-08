#!/usr/bin/env bats

setup() {
  source function/platform/name.bash
}

uname() {
  echo "$uname_result"
}

lsb_release() {
  echo "$lsb_release_result"
}

@test "returns 'mac' if the current platform is Darwin" {
  uname_result='Darwin'

  [ "$(platform::name)" = 'mac' ]
}

@test "returns 'debian' if the current platform is Debian" {
  uname_result='Linux'
  lsb_release_result='Debian'

  [ "$(platform::name)" = 'debian' ]
}

@test "returns 'linux' if the current platform is an unknown Linux distro" {
  uname_result='Linux'
  lsb_release_result='Foo'

  [ "$(platform::name)" = 'linux' ]
}
