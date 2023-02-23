import 'apt::install'
import 'arguments::expect'
import 'log::error'
import 'variable::expect'
import 'variable::nonempty'

debian::install() {
  arguments::expect $# # none
  variable::expect 'recipe'

  if variable::nonempty 'apt_package'; then
    apt::install "${apt_package:?}"
    return
  fi

  if variable::nonempty 'program'; then
    apt::install "${program:?}"
    return
  fi

  log::error 'debian' "don't know how to install ${recipe:?}"
  return 1
}
