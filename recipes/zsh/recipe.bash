import 'file::append'
import 'file::contains'
import 'log'
import 'platform::login_shell'
import 'platform::name'
import 'platform::safe_link'
import 'prompt::yes_or_no'
import 'user::root'

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
  platform="$(platform::name)" || return
  local zsh_path
  platform="$(__zsh::path "$platform")" || return
  local login_shell
  login_shell="$(platform::login_shell)" || return

  if [[ "$login_shell" != "$zsh_path" ]]; then
    local answer
    if answer="$(prompt::yes_or_no "$platform" "do you want to set zsh as login shell (current: $login_shell)?" 'Yes')" \
      && [[ "$answer" == 'Yes' ]]; then
      log trace "$platform" 'changing login shell to zsh'
      if [[ "$platform" != 'mac' ]] || file::contains '/etc/shells' '/usr/local/bin/zsh'; then
        chsh -s "$zsh_path"
      else
        if user::root; then
          file:append '/etc/shells' '/usr/local/bin/zsh' && chsh -s "$zsh_path"
        else
          log warn "$platform" 'running as non-root' 'sudo is needed!'
          sudo file:append '/etc/shells' '/usr/local/bin/zsh' && chsh -s "$zsh_path"
        fi
      fi
    else
      log trace "$platform" "$login_shell will remain the login shell"
    fi
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
