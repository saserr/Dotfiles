import 'arguments::expect'

apt::missing() {
  arguments::expect $# 'package'

  local package=$1

  ! grep -Fxq 'Status: install ok installed' <(dpkg -s "$package" 2>&1)
}
