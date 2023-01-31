import 'arguments::expect'

file::empty() {
  arguments::expect $# 'file'

  local file=$1

  [ ! -s "$file" ]
}
