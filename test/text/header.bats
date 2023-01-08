#!/usr/bin/env bats

setup() {
  source src/text/header.bash
}

@test "without arguments" {
  [ "$(text::header)" = '**********' ]
}

@test "with an empty message" {
  [ "$(text::header '')" = '**********' ]
}

@test "with a non-empty message" {
  [ "$(text::header 'foo')" = $'*******\n* foo *\n*******' ]
}
