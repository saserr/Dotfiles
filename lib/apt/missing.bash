import 'arguments::expect'

apt::missing() {
  arguments::expect $# 'package'

  local package=$1

  ! dpkg -s "$package" 2>&1 | grep -q 'Status: install ok installed'
}
