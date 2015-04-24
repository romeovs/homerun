#!/usr/bin/env sh
function run {
  dir="$1"
  tool=$(basename $dir)
  if [ -d "$dir" ]; then
    install="$dir/install"
    if [ -f "$install" ]; then
      step 'installing zsh'
      cd "$dir"
      sh "$install"
    fi
  fi
}

function install {
  # intialize cache dir
  mkdir -p "$XDG_CACHE_HOME"

  if [ $# -eq 1 ]; then
    # run global install script first
    run "$XDG_CONFIG_HOME/install"
  fi

  visit run "$@"
  finish install completed
}
# vim: ft=sh
