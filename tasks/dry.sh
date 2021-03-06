#!/usr/bin/env sh

run() {
  dir="$1"
  tool=`basename "$dir"`
  if [ -d "$dir" ]; then
    install="$dir/install"
    if [ -f "$install" ]; then
      step installing "$t$tool"
      sed -e '/^ *#/ d' -e '/^$/ d' -e 's/^\(.*\)/  \1/' "$install"
    fi
  fi
}


dry() {
  start dry-running with this environment
  echo "  \$HOME=$HOME
  \$XDG_CONFIG_HOME=$XDG_CONFIG_HOME
  \$XDG_CACHE_HOME=$XDG_CACHE_HOME"

  # intialize cache dir
  step mkdir "$XDG_CACHE_HOME"

  if [ $# -eq 0 ]; then
    # run global install script first
    run "$XDG_CONFIG_HOME"
  fi

  visit run "$@"
  finish dry-run completed
}

export help_arg="[`arg toolname`...]"
export help_msg="
Dry run an install.

Works the same as \`homerun install\` but just
lists the steps that would be taken instead of
actually performing them.
"

# vim: ft=sh
