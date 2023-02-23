import 'command::exists'
import 'file::empty'
import 'log::trace'
import 'log::warn'

program='git'
recommended=('git-lfs')

recipe::configure() {
  log::trace 'git' 'setting up .gitconfig'
  ./configure

  if command::exists curl; then
    log::trace 'git' 'setting up .gitignore'
    if file::empty "$HOME/.gitignore"; then
      echo >>"$HOME/.gitignore"
    fi

    case "$(platform::name)" in
      'mac')
        curl https://www.toptal.com/developers/gitignore/api/macos >>"$HOME/.gitignore"
        ;;
      *)
        curl https://www.toptal.com/developers/gitignore/api/linux >>"$HOME/.gitignore"
        ;;
    esac
  else
    log::warn 'git' 'skipping setting up .gitignore; no curl'
  fi
}
