#!/usr/bin/env bats

setup() {
  source function/text/header
}

@test "with a missing argument" {
  [ "$(text::header)" = '**********' ]
}

@test "with an empty message" {
  [ "$(text::header '')" = '**********' ]
}

@test "with a non-empty message" {
  [ "$(text::header 'foo')" = $'*******\n* foo *\n*******' ]
}
