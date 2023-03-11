#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'platform::name'
}

@test "returns 'mac' if the current platform is 'Darwin'" {
  load '../helpers/mocks/stub.bash'

  stub uname '-s : echo "Darwin"'

  [[ "$(platform::name)" == 'mac' ]]

  unstub uname
}

@test "returns ID from /etc/os-release if the current platform is 'Linux'" {
  load '../helpers/mocks/stub.bash'
  import 'abort'
  import 'caller::location'
  import 'caller::name'

  stub uname '-s : echo "Linux"'
  source() {
    if [[ "$1" == '/etc/os-release' ]]; then
      ID='foo'
    else
      local messages=("is mocked")
      local -i level=1
      if [[ "$(caller::name)" == 'import' ]]; then
        level=2
      fi
      local location
      if location="$(caller::location $level)"; then
        messages+=("at $location")
      fi
      abort "source" "${messages[@]}"
    fi
  }

  [[ "$(platform::name)" == 'foo' ]]

  unstub uname
}
