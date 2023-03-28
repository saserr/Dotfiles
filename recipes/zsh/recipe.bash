import 'file::append'
import 'file::contains'
import 'log'
import 'platform::is_root'
import 'platform::login_shell'
import 'platform::name'
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
  local login_shell
  login_shell="$(platform::login_shell)" || return 1

  if [[ "$login_shell" != "$zsh_path" ]]; then
    case $(prompt::yes_or_no "$platform" "do you want to set zsh as login shell (current: $login_shell)?" 'Yes') in
      Yes)
        log trace "$platform" 'changing login shell to zsh'
        if [[ "$platform" != 'mac' ]] || file::contains '/etc/shells' '/usr/local/bin/zsh'; then
          chsh -s "$zsh_path"
        else
          if platform::is_root; then
            file:append '/etc/shells' '/usr/local/bin/zsh' && chsh -s "$zsh_path"
          else
            log warn "$platform" 'running as non-root; sudo is needed'
            sudo file:append '/etc/shells' '/usr/local/bin/zsh' && chsh -s "$zsh_path"
          fi
        fi
        ;;
      No)
        log trace "$platform" "$login_shell will remain the login shell"
        ;;
    esac
  fi

  log trace 'zsh' 'setting up .zshenv'
  if platform::safe_link '.zshenv' "$HOME/.zshenv" "$PWD/zshenv" && touch "$HOME/.zshenv.local.zsh"; then
    log trace 'zsh' 'save the local specific zsh environment configuration into ~/.zshenv.local.zsh'
  fi

  log trace 'zsh' 'setting up .zshrc'
  if platform::safe_link '.zshrc' "$HOME/.zshrc" "$PWD/zshrc" && touch "$HOME/.zshrc.local.zsh"; then
    log trace 'zsh' 'save the local specific zsh configuration into ~/.zshrc.local.zsh'
  fi
}
