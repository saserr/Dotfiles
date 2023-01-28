import 'arguments::expect'

file::append() {
  arguments::expect $# 'file' '[text]'

  local file=$1
  local text=$2

  echo "$text" >>"$file"
}
