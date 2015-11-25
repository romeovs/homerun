#!/usr/bin/env sh
run() {
  local dir="$1"
  if [ -d "$dir" ]; then
    install="$dir/install"
    if [ -f "$install" ]; then
      step "installing $1"
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
  finish install completed
}
# vim: ft=sh
