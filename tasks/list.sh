#!/usr/bin/env sh
function run {
  dir="$1"
  tool=$(basename $dir)
  if [ -d "$dir" ]; then
    if [ $tool != 'bin' ]; then
      echo $tool
    fi
  fi
}

function list {
  visit run "$@"
}
# vim: ft=sh
