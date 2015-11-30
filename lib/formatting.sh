
ul=`tput smul`
b=`tput bold`
n=`tput sgr0`
t=`tput setaf 6`
xdgh="${b}\$XDG_CONFIG_HOME${n}"
hh="${b}\$HOME${n}"


function arg() {
  printf "<${ul}$1${n}>"
}

function title() {
  echo "${b}$@${n}"
}

function indent() {
  local spaces=`printf "%$1s"`
  printf "$2" | sed "s/^/$spaces/"
}

