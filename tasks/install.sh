#!/usr/bin/env sh
run() {
  local dir="$1"
  if [ -d "$dir" ]; then
    install="$dir/install"
    if [ -f "$install" ]; then
      step "executing $dir"
      cd "$dir"
      sh "$install"
    fi
  fi
}

install() {
  # intialize cache dir
  mkdir -p "$XDG_CACHE_HOME"

  if [ $# -eq 1 ]; then
    # run global install script first
    run "$XDG_CONFIG_HOME/install"
  fi

  visit run "$@"
  finish "install completed"
}


export help_arg="[`arg toolname`...]"
export help_msg="
execute install scripts.

runs $xdgh/`arg toolname`/install for every
`arg toolname` in the list of arguments.

If no arguments are given, the install scripts for
all tools in $xdgh are run, in addition
to the global install file at $xdgh.
"

# vim: ft=sh
