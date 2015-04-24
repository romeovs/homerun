
# describe a step in the process
function step {
  echo '\033[0;34m==>\033[0m\033[1m' "$@" '\033[0m'
}

# display an error
function error {
  echo '\033[0;31m'Error: $1'\033[0m'
  exit 1
}

# run a specific task
function runtask {
  local task=$1
  # task script location
  local script="${homerun}/tasks/${task}.sh"

  # run script if it exists, error if not
  if [ -f "$script" ]; then
    source "$script"
    ${task} "$@"
  else
    error "unkown task \`${task}\`"
  fi
}


function visit {
  local fn=$1
  shift
  if [ $# -gt 1 ]; then
    for arg in "$@"; do
      dir="$XDG_CONFIG_HOME/$arg"
      $fn "$dir"
    done
  else
    for dir in "$XDG_CONFIG_HOME"/*; do
      $fn "$dir"
    done
  fi
}
