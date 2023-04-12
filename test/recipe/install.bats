#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
}

@test "fails if platform::name fails" {
  load '../helpers/import.bash'
  import 'assert::exits'
  import 'capture::stderr'
  import 'file::write'
  import 'log'

  local script="$BATS_TEST_TMPDIR/foo"
  file::write "$script" \
    '#!/usr/bin/env bash' \
    'platform::name() { return 1; }' \
    "source 'lib/import.bash'" \
    "import 'recipe::install'" \
    "recipe::install"
  chmod +x "$script"

  run "$script"

  ((status == 3))
  ((${#lines[@]} == 3))
  [[ "${lines[0]}" == "$(capture::stderr log error 'recipe::install' 'unable to determine the platform name')" ]]
  [[ "${lines[1]}" == "$(capture::stderr log error 'import' "can't load the 'recipe::install' function")"* ]]
  [[ "${lines[2]}" == "         at $script (line: 5)" ]]
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
  # capture::stderr indirectly depends on platform::name
  local error_message
  error_message="$(capture::stderr log error 'windows' "don't know how to install foo")"

  platform::name() { echo 'windows'; }

  local recipe='foo'
  run recipe::install

  ((status == 1))
  [[ "$output" == "$error_message" ]]
}
