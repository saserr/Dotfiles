import 'log'

program='git-lfs'

recipe::configure() {
  log trace 'git-lfs' 'installing for the current user'
  git lfs install
}
