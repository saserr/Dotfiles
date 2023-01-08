#!/usr/bin/env bats

setup() {
  source src/platform/login_shell.bash
}

@test "returns 'bash' if $SHELL is /bin/bash" {
  SHELL=/bin/bash

  [ "$(platform::login_shell)" = 'bash' ]
}

@test "returns 'bash' if $SHELL is /usr/bin/bash" {
  SHELL=/usr/bin/bash

  [ "$(platform::login_shell)" = 'bash' ]
}

@test "returns 'bash' if $SHELL is /usr/local/bin/bash" {
  SHELL=/usr/local/bin/bash

  [ "$(platform::login_shell)" = 'bash' ]
}

@test "returns 'zsh' if $SHELL is /bin/zsh" {
  SHELL=/bin/zsh

  [ "$(platform::login_shell)" = 'zsh' ]
}

@test "returns 'zsh' if $SHELL is /usr/bin/zsh" {
  SHELL=/usr/bin/zsh

  [ "$(platform::login_shell)" = 'zsh' ]
}

@test "returns 'zsh' if $SHELL is /usr/local/bin/zsh" {
  SHELL=/usr/local/bin/zsh

  [ "$(platform::login_shell)" = 'zsh' ]
}

@test "returns $SHELL if it is an unknown shell" {
  SHELL=/bin/foo

  [ "$(platform::login_shell)" = '/bin/foo' ]
}
