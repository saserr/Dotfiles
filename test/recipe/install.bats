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
  platform::name() { echo 'windows'; }
  import 'log::error'
  import 'recipe::install'

  local recipe='foo'

  run recipe::install

  ((status == 1))
  [ "$output" = "$(log::error 'windows' "don't know how to install foo")" ]
}
