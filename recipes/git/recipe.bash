import 'command::exists'
import 'file::append'
import 'file::empty'
import 'log'

program='git'
recommended=('git-lfs')

recipe::configure() {
  log trace 'git' 'setting up .gitconfig'
  ./configure

  if command::exists 'curl'; then
    log trace 'git' 'setting up .gitignore'
    if ! file::empty "$HOME/.gitignore"; then
      file::append "$HOME/.gitignore"
    fi

    local platform
    platform="$(platform::name)" || return
    case "$platform" in
      'mac')
        curl 'https://www.toptal.com/developers/gitignore/api/macos' >>"$HOME/.gitignore" || return
        ;;
      *)
        curl 'https://www.toptal.com/developers/gitignore/api/linux' >>"$HOME/.gitignore" || return
        ;;
    esac
  else
    log warn 'git' 'no curl' 'skipping setting up .gitignore'
  fi
}
