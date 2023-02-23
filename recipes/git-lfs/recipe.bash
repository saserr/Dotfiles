import 'log::trace'

program='git-lfs'

recipe::configure() {
  log::trace 'git-lfs' 'installing for the current user'
  git lfs install
}
