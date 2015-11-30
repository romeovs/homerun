function read_task() {
  local task="$1"
  local script="$homerun/tasks/${task}.sh"
  help_msg=''
  help_arg=''


  if [ -f "$script" ]; then
    source "$script"
  else
    error "task named \`$task\` does not exist."
  fi
}

function help_for_task() {
  local task="$1"

  read_task "$task"

  printf "  \033[1m%s\033[0m %s\n    %s\n\n" $task "$help_arg" "`indent 4 "$help_msg"`"
  help_msg=''
  help_arg=''
}

description="
Homerun is a simple dotfile management tool.
It does nothing more that give you a bit of a framework
to structure your dotfiles and be able to keep them under
source control.
"

configuration="
All configuration files are kept under $xdgh, using a directory
per 'tool' that needs configuration. For instance, if you want to keep
vim under homerun control, create a directory named 'vim' in $xdgh and
put .vimrc and .vim/ there (dropping the leading dots for convenience
and renaming .vim/ to vimfiles/):

  $xdgh
    vim/
      vimrc
      vimfiles
      include
      install

The reasons for the  include and install files will become clear
in the following sections.

We now need to somehow tell our environment that the configuration
for vim is not stored under $hh anymore. The explaination of mechanisms
to do so can be found in the next sections. In each of these sections,
vim will be used as the principle example of how to configure homerun.

`title INCLUDE SCRIPTS`

Most dotfile managers keep files in a certain directory like we
keep them in $xdgh, however, they often use symlinks to $hh
so your tools can find them.  homerun uses a different approach.

Instead of symlinking all of the config and re-cluttering the $hh
directory again we just need a way to tell our tools the new location
of their config.

Every tool can have a file called include inside their directory that
specifies some thing that the shell needs to include when launching.
This can be used to override how your tools are called. For instance
the include script in the vim config directory might look like this:

  export EDITOR=\"nvim -u \$XDG_CONFIG_HOME/vim/vimrc\"
  alias vim=\"\$EDITOR\"

This tells the shell that vim is to be used zith the  '-u' option
that tells it to look for a config file in $xdgh/vim/vimrc instead
of $hh/.vimrc.

The include scripts can also be placed under a directory named
inlude/ in a tool's config dir.  This is handy when you have a lot
of unrelated things you want to include and you want to split up the code.
For example, one might want to split up the include script for a tool
named foo into two scripts: alias and completion:

  $xdgh
    foo/
      include/
        alias
        completion

`title INSTALL SCRIPTS`

Some tools do need symlinking because they really do expect a config file
under $hh and provide no flag to alter this behaviour.  Some scripts
might also need some installation steps to be performed, like installing
dependencies etc.

To accomplish this, you can add a script called install to the tool's config.
For instance, because we're using neovim instead of nvim, we need to install
this first (it is not there by default) before we can start using it. The
install script in $xdgh/vim might look like this:

  # install the neovim dependency
  brew install neovim/neovim/neovim

To run the install script for vim, you can use the following command:

  homerun install vim

You can also put an install script in $xdgh directly. This
will be called before all other install scripts and can therefore
be used to install global dependencies.  For instance:

  # install brew
  echo 'installing homebrew...'
  ruby -e \`curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install\`

`title BIN DIRECTORIES`

If you have scripts you keep under source control in the
config directory, you can put them under the tool's bin/ directory.

For example, I keep homerun itself in my $xdgh:

  $xdgh
    homerun/
      bin/
        homerun

If you have scripts that you want to keep in the config repo, but that do not
need additional configuration, put them in $xdgh/bin.

Homerun will make sure all executable scripts in any bin directory
will be added to your ${b}\$PATH${n} variable.

`title ENABLING HOMERUN`

To enable all of the features described above, you need to
source the homerun initialization script each time you start your
shell. To do this, add the following line to the top of your .profile:

  source \"\$XDG_CONFIG_HOME/homerun/initialize\"

This will:

  - include every include script under homerun
  - add every bin/ directory to your path

"

usage="Usage: homerun `arg task` [`arg argument`...] [-h]"

options="
$b-h, --help$n  show help (same as homerun help)
"

function help() {

  local rest=""
  local N=0
  local long=0

  for opt in "$@"; do
    case "$opt" in
      -l | --long)
        long=1
        ;;
      *)
        rest="$rest $opt"
        N=$(( N + 1 ))
        ;;
    esac
  done

  if [ $N -eq 0 ]; then
    echo "$usage"

    echo
    title DESCRIPTION
    indent 2 "$description"

    echo
    title OPTIONS
    indent 2 "$options"

    echo
    title TASKS
    echo

    for script in "$homerun"/tasks/*; do
      local task=`basename $script`
      help_for_task "${task%.sh}"
    done

    if [ $long -eq 1 ]; then
      title CONFIGURATION
      indent 2 "$configuration"
    fi
  elif [ $N -eq 1 ]; then
    local task="$1"

    read_task "$task"

    echo "Usage: homerun $task $help_arg"
    indent 2 "$help_msg"
  else
    # multiple tasks given
    echo "$usage"
    echo
    title TASKS
    echo

    for task in "$@"; do
      help_for_task "$task"
    done
  fi
}

export help_arg="[`arg taskname`...] [-l]"
export help_msg="
Print help messages for tasks.

`title task options`

$b-l, --long$n  show long help

Prints the help message and usage information for
each of the requested `arg taskname`. If no argument is provided,
it prints the help of all tasks.
"
