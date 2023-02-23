import 'file::append'
import 'file::empty'
import 'log::error'
import 'log::trace'
import 'platform::login_shell'

program='starship'
debian_required=('curl')

debian::install() {
  curl -sS 'https://starship.rs/install.sh' | sh
}

recipe::configure() {
  local login_shell
  login_shell="$(platform::login_shell)" || return 1
  case "$login_shell" in
    'zsh')
      log::trace 'starship' 'enabling in zsh'

      local zshrc
      if setup::missing 'zsh'; then
        zshrc="$HOME/.zshrc"
      else
        zshrc="$HOME/.zshrc.local.zsh"
      fi

      if ! file::empty "$zshrc"; then
        file::append "$zshrc"
      fi
      file::append "$zshrc" '# enable https://starship.rs' || return 1
      # shellcheck disable=SC2016
      # this eval is intentionally not evaluated here, hence single-quote string
      file::append "$zshrc" 'eval "$(starship init zsh)"' || return 1
      ;;
    'bash')
      log::trace 'starship' 'enabling in bash'

      local bashrc="$HOME/.bashrc"
      if ! file::empty "$bashrc"; then
        file::append "$bashrc"
      fi
      file::append "$bashrc" '# enable https://starship.rs' || return 1
      # shellcheck disable=SC2016
      # this eval is intentionally not evaluated here, hence single-quote string
      file::append "$bashrc" 'eval "$(starship init bash)"' || return 1
      ;;
    *)
      log::error 'starship' "don't know how to enable for $login_shell"
      return 1
      ;;
  esac
}
