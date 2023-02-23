import 'file::append'
import 'file::contains'
import 'log::trace'
import 'platform::name'
import 'platform::login_shell'
import 'platform::safe_link'
import 'prompt::yes_or_no'

program='zsh'
recommended=('starship')

__zsh::path() {
  local platform=$1
  if [[ $platform == mac ]]; then
    echo '/usr/local/bin/zsh'
  else
    echo '/bin/zsh'
  fi
}

recipe::configure() {
  local platform
  platform="$(platform::name)" || return 1
  local zsh_path
  platform=$(__zsh::path "$platform") || return 1

  if [[ $SHELL != "$zsh_path" ]]; then
    case $(prompt::yes_or_no "$platform" "do you want to set zsh as login shell (current: $(platform::login_shell))?" 'Yes') in
      Yes)
        log::trace "$platform" 'changing login shell to zsh'
        if [[ "$platform" == 'mac' ]]; then
          if ! file::contains '/etc/shells' '/usr/local/bin/zsh'; then
            sudo file:append '/etc/shells' '/usr/local/bin/zsh'
          fi
        fi
        chsh -s "$zsh_path"
        ;;
      No)
        log::trace "$platform" "$(platform::login_shell) will remain the login shell"
        ;;
    esac
  fi

  log::trace 'zsh' 'setting up .zshenv'
  platform::safe_link '.zshenv' "$HOME/.zshenv" "$PWD/zshenv"

  log::trace 'zsh' 'save the local specific zsh environment configuration into ~/.zshenv.local.zsh'
  touch "$HOME/.zshenv.local.zsh"

  log::trace 'zsh' 'setting up .zshrc'
  platform::safe_link '.zshrc' "$HOME/.zshrc" "$PWD/zshrc"

  log::trace 'zsh' 'save the local specific zsh configuration into ~/.zshrc.local.zsh'
  touch "$HOME/.zshrc.local.zsh"
}
