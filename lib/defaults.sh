# set config home
if [ -z "$XDG_CONFIG_HOME" ]; then
  echo '$XDG_CONFIG_HOME not set, falling back to `~/.config`'
  export XDG_CONFIG_HOME="$HOME/.config"
fi

# set cache path
if [ -z "$XDG_CACHE_HOME" ]; then
  echo '$XDG_CACHE_HOME not set, falling back to `~/.cache`'
  export XDG_CACHE_HOME="$HOME/.cache"
fi
