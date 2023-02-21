#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
}

@test "uses greadlink on mac platform" {
  platform::name() { echo 'mac'; }
  import 'platform::readlink'

  load '../helpers/mocks/stub.bash'
  stub greadlink ':'

  platform::readlink

  unstub greadlink
}

@test "passes all arguments greadlink on mac platform" {
  platform::name() { echo 'mac'; }
  import 'platform::readlink'

  load '../helpers/mocks/stub.bash'
  stub greadlink 'foo bar baz : '

  platform::readlink 'foo' 'bar' 'baz'

  unstub greadlink
}

@test "fails if greadlink fails on mac platform" {
  platform::name() { echo 'mac'; }
  import 'platform::readlink'

  load '../helpers/mocks/stub.bash'
  stub greadlink ': exit 1'

  ! platform::readlink

  unstub greadlink
}

@test "fails if greadlink is missing on mac platform" {
  import 'log::error'

  command::exists() { [[ "$1" != 'greadlink' ]]; }
  platform::name() { echo 'mac'; }
  import 'platform::readlink'

  run platform::readlink 'foo'

  ((status == 2))
  [[ "$output" == "$(log::error 'mac' 'greadlink is missing')" ]]
}

@test "exits if greadlink is missing on mac platform" {
  platform::name() { echo 'mac'; }
  import 'platform::readlink'

  command::exists() { [[ "$1" == 'greadlink' ]] && return 1; }
  fail() {
    echo 'foo'
    platform::readlink 'foo' 2>/dev/null
    echo 'bar'
  }

  run fail

  ((status == 2))
  [[ "$output" == 'foo' ]]
}

@test "uses readlink on any other platform" {
  platform::name() { echo 'debian'; }
  import 'platform::readlink'

  load '../helpers/mocks/stub.bash'
  stub readlink ':'

  platform::readlink

  unstub readlink
}

@test "passes all arguments to readlink on any other platform" {
  platform::name() { echo 'debian'; }
  import 'platform::readlink'

  load '../helpers/mocks/stub.bash'
  stub readlink 'foo bar baz : '

  platform::readlink 'foo' 'bar' 'baz'

  unstub readlink
}

@test "fails if readlink fails on any other platform" {
  platform::name() { echo 'debian'; }
  import 'platform::readlink'

  load '../helpers/mocks/stub.bash'
  stub readlink ': exit 1'

  ! platform::readlink

  unstub readlink
}
