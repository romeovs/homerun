#!/usr/bin/env sh
run() {
  dir="$1"
  tool=$(basename "$dir")
  if [ -d "$dir" ]; then
    if [ "$tool" != 'bin' ]; then
      echo "$tool"
    fi
  fi
}

list() {
  visit run "$@"
}
# vim: ft=sh
