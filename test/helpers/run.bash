# redeclare run as __run
__run="$(declare -f 'run')"
__run="${__run/run/__run}"
eval "$__run"

abort::in_subshell() {
  [[ "$__run_parent" ]] && ((BASHPID != __run_parent))
}

# shellcheck disable=SC2317
# __as_parent is called by the __run function bellow
__as_parent() {
  local command=$1
  local arguments=("${@:2}")

  __run_parent=$BASHPID
  $command "${arguments[@]}"
}

# declare new run command
run() {
  local command=$1
  local arguments=("${@:2}")

  if [[ "$__run_parent" ]]; then
    __run "$command" "${arguments[@]}"
  else
    __run __as_parent "$command" "${arguments[@]}"
  fi
}
