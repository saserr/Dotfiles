#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'recipe::file'
}

@test "returns the location of the \$recipe's configuration" {
  local recipe=foo

  run recipe::file

  ((status == 0))
  [[ "$output" == "${recipe}/recipe" ]]
}

@test "fails if \$recipe is missing" {
  import 'log::error'

  run recipe::file

  ((status == 2))
  [[ "${lines[0]}" == "$(log::error 'recipe::file' "expected nonempty variables: recipe")" ]]
}
