#!/bin/env sh

function log() {
  if [ -t 1 ]; then
    echo '\033[0;33m==>\033[0m' $@
  else
    echo $@
  fi
}

function error() {
  if [ -t 1 ]; then
    echo '\033[0;31mInstallation failed:\033[0m' $@
  else
    echo "Installation failed, reason:" $@
  fi
  exit 1
}

log "Installing homerun..."

# set config home
if [ -z "$XDG_CONFIG_HOME" ]; then
  log '$XDG_CONFIG_HOME not set, falling back to `~/.config`'
  export XDG_CONFIG_HOME="$HOME/.config"
fi

log "\$XDG_CONFIG_HOME=$XDG_CONFIG_HOME"

homerun="$XDG_CONFIG_HOME/homerun"
repo="https://github.com/romeovs/homerun"

mkdir -pv "$homerun"


if hash git 2>/dev/null; then
  # has git
  log Using git to install homerun
  cd "$XDG_CONFIG_HOME"
  git clone "$repo" "$homerun" || error "git clone failed."
else
  # does not have git
  log "You do not have git installed, using curl"
  cd "$homerun"
  curl -Lk "$repo/archive/master.tar.gz" | tar zx --strip=1 || error "curl failed."
fi

source "$homerun/initialize"

echo "homerun succesfully installed!"
