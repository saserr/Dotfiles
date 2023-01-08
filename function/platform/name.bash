platform::name() {
  local os_name
  os_name="$(uname -s)"

  case $os_name in
  'Darwin')
    echo 'mac'
    ;;
  'Linux')
    if [[ "$(lsb_release -is)" == 'Debian' ]]; then
      echo 'debian'
    else
      echo 'linux'
    fi
    ;;
  *)
    echo "$os_name"
    ;;
  esac
}