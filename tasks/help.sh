
function help_for_task() {
  local task="$1"
  local script="$homerun/tasks/${task}.sh"
  help_msg=''
  help_arg=''

  source "$script"
  local name=`basename $script`
  local task="${name%.sh}"
  printf "  \033[1m%s\033[0m %s\n    %s\n" $task "$help_arg" "$help_msg"
  help_msg=''
  help_arg=''
}

function help() {
  shift

  if [ $# -eq 0 ]; then
    echo 'Usage: homerun <task> [arguments...]'
    echo
    echo 'available tasks:'

    for script in "$homerun"/tasks/*; do
      local task=`basename $script`
      help_for_task "${task%.sh}"
    done
  elif [ $# -eq 1 ]; then
    local task="$1"
    local script="$homerun/tasks/${task}.sh"
    source "$script"

    echo "Usage: homerun $task $help_arg"
    echo "$help_msg"
  else
    echo 'Usage: homerun <task> [arguments...]'
    echo
    echo 'tasks:'
    for task in "$@"; do
      help_for_task "$task"
    done
  fi


}

export help_args="[taskname1 [taskname2 [...]]]"
export help_msg="
    Print help messages for tasks.

    Prints the help message and usage information for
    each of the provided tasknames. If no task is provided,
    it prints the help of all tasks.
"
