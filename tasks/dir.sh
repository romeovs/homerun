
function dir() {
  local tool="$1"
  local dir="$XDG_CONFIG_HOME/$tool"

  if [ -d "$dir" ]; then
    cd "$dir"
  else
    error "no such tool \`$tool\`"
  fi
}
