import 'log'

log::warn() {
  # bold yellow
  log '1;33' "$@"
}
