import 'arguments::expect'

homebrew::missing() {
  arguments::expect $# 'formula'

  local formula=$1

  ! brew list "$formula" >/dev/null 2>&1
}
