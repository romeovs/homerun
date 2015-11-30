

function log {
  echo '\033[0;34mhomerun \033[1;30m•\033[1m' "$@"
}

# describe a step in the process
function step {
  log '\033[0m'"$@" '\033[0m'
}

# display an error
function error {
  log "\033[0;31merror: $1\033[0m"
  exit 1
}

# run a specific task
function runtask {
  local task="$1"
  local script="${homerun}/tasks/${task}.sh"
  shift

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
  shift
  if [ $# -gt 0 ]; then
    for arg in "$@"; do
      dir="$XDG_CONFIG_HOME/$arg"
      if [ -d "$dir" ]; then
        $fn "$dir"
      else
        error "config for '$dir' does not exist."
      fi
    done
  else
    for dir in "$XDG_CONFIG_HOME"/*; do
      $fn "$dir"
    done
  fi
}

function finish {
  echo '\033[32m✓\033[0m' "$@"
}
