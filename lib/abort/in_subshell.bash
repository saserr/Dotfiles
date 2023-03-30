import 'arguments::expect'

# TODO rename
# TODO tests

abort::in_subshell() {
  arguments::expect $# # none

  ((BASH_SUBSHELL > 0))
}
