#!/usr/bin/env sh

function run {
  dir="$1"
  tool=$(basename $dir)
  if [ -d "$dir" ]; then
    install="$dir/install"
    if [ -f "$install" ]; then
      step installing $tool
      cat "$install" | sed -e '/^ *#/ d' -e '/^$/ d' -e 's/^\(.*\)/  \1/'
    fi
  fi
}


function dry {
  step dry-running with this environment
  echo "  \$HOME="$HOME"
  \$XDG_CONFIG_HOME=$XDG_CONFIG_HOME
  \$XDG_CACHE_HOME=$XDG_CACHE_HOME"

  # intialize cache dir
  step mkdir "$XDG_CACHE_HOME"

  if [ $# -eq 1 ]; then
    # run global install script first
    run "$XDG_CONFIG_HOME/install"
  fi

  visit run "$@"
  finish dry-run completed
}

# vim: ft=sh