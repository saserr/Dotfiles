#!/usr/bin/env bats

setup() {
  source function/setup/missing
}

@test "is missing if profile has not been set up" {
  setup::missing 'test'
}

@test "is not missing if profile has been set up" {
  mkdir -p ~/.setup/
  touch ~/.setup/test

  ! setup::missing 'test'
}