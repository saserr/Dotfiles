#!/usr/bin/env bats

setup() {
  source function/text/header
}

@test "with a missing argument" {
  skip 'broken'
  [ "$(text::header)" = '**********' ]
}

@test "with an empty message" {
  skip 'broken'
  [ "$(text::header '')" = '**********' ]
}

@test "with a non-empty message" {
  [ "$(text::header 'foo')" = $'*******\n* foo *\n*******' ]
}
