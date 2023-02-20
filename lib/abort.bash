import 'arguments::expect'
import 'log::error'

abort() {
  arguments::expect $# 'tag' 'message' '...'

  local tag=$1
  local messages=("${@:2}")

  log::error "$tag" "${messages[@]}" 1>&2
  exit 2
}
