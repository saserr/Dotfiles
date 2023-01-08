#!/usr/bin/env bats

setup() {
  source src/prompt/yes_or_no.bash
}

@test "prompts the choices" {
  eof=$'\x04'

  run prompt::yes_or_no <<<"$eof"

  [ "${lines[0]}" = '1) Yes' ]
  [ "${lines[1]}" = '2) No' ]
}

@test "answer 1 is Yes" {
  run prompt::yes_or_no <<<'1'

  [ $status -eq 0 ]
  [ "${lines[2]}" = '#? Yes' ]
}

@test "answer 2 is No" {
  run prompt::yes_or_no <<<'2'

  [ $status -eq 0 ]
  [ "${lines[2]}" = '#? No' ]
}
