#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
}

@test "uses mac::install on mac platform" {
  platform::name() { echo 'mac'; }

  import 'recipe::install'

  local -i called=0
  mac::install() { called=$called+1; }

  recipe::install

  ((called == 1))
}

@test "uses debian::install on debian platform" {
  platform::name() { echo 'debian'; }

  import 'recipe::install'

  local -i called=0
  debian::install() { called=$called+1; }

  recipe::install

  ((called == 1))
}

@test "fails on any other platform" {
  load '../helpers/import.bash'
  import 'capture::stderr'
  import 'log'
  import 'recipe::install'

  # capture error message before platform::name is mocked because
  # capture::stderr depends on platform::name
  local error_message
  error_message="$(capture::stderr log error 'windows' "don't know how to install foo")"

  platform::name() { echo 'windows'; }

  local recipe='foo'
  run recipe::install

  ((status == 1))
  [[ "$output" == "$error_message" ]]
}
