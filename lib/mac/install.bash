import 'arguments::expect'
import 'homebrew::install'
import 'log::error'
import 'variable::expect'
import 'variable::nonempty'

mac::install() {
  arguments::expect $# # none
  variable::expect 'recipe'

  if variable::nonempty 'homebrew_formula'; then
    homebrew::install "${recipe:?}" "${homebrew_formula:?}"
    return
  fi

  if variable::nonempty 'program'; then
    homebrew::install "${recipe:?}" "${program:?}"
    return
  fi

  log::error 'mac' "don't know how to install ${recipe:?}"
  return 1
}
