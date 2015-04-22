# Homerun

Homerun is a simple dotfile management tool.
It does nothing more that give you a bit of a framework
to structure your dotfiles and be able to keep them under
source control.

`homerun` is based on a few simple principles:

  - config should be put under `$XDG_CONFIG_HOME`, not `$HOME`
  - do not use symlinks to `$HOME` when not necessary
  - config for one tool should be as un-scattered as possible
  - leave version control to the user

## "The" solution
`homerun` tries to accomplish the above by providing a simple
structure.  All dotfiles are kept under `$XDG_CONFIG_HOME`, every tool
has its own subdirectory like so:

```
$XDG_CONFIG_HOME/
  git/
    config
    ignore
  vim/
    vimrc
    vimfiles/
  zsh/
    functions/
    .zprofile
    .zshrc
    zshenv
```

## include scripts

Most dotfile managers keep files in a certain directory like the above,
but the way they handle using them is different in `homerun`.  Most tools
symlink all the files back to `$HOME` so your tools can find them.  I didn't
like this, so I took a different approach.

Every tool can have a file called `include` inside their directory that
specifies how the tool should be called.  For instance, the `include`
script in the `vim` config directory might look like this:

```sh
export EDITOR="nvim -u $XDG_CONFIG_HOME/vim/vimrc"
alias vim="$EDITOR"
```

This tells `vim` to start with the `-u` option that tells it to
look for a config file in `$XDG_CONFIG_HOME/vim/vimrc` instead of `~/.vimrc`.

`homerun` provides a simple script that can be sourced by your shell 
config file that automatically includes all the `include` scripts inside
`$XDG_CONFIG_HOME`.  To use it, add the following to your shell's rc file:

```sh
source "$XDG_CONFIG_HOME/homerun/initialize"
```
(assuming `homerun` is installed under `$XDG_CONFIG_HOME/homerun`).

The include scripts can also be placed under a directory named
`inlude/` in a tool's config dir.  This is handy when you have a lot
of unrelated things you want to include and you want to split up the code.
For example, one might want to split up the `include` script for a tool
named `foo` into two scripts: `alias` and `completion`:

```
$XDG_CONFIG_HOME/
  foo/
    include/
      alias
      completion
    ...
```

## install scripts
Some tools do need symlinking because they really do expect a config file
under `$HOME` and provide no flag to alter this behaviour.  Some scripts
might also need some installation steps to be performed, like installing
dependencies etc.

To accomplish this, you can add a script called `install` to the tool's config
directory.  For instance, the `zsh` config dir might contain and `install`
script:

```sh
# install zsh and some dependencies
brew install zsh ffind

# link the zshenv into $HOME
ln -s "$XDG_CONFIG_HOME/zsh/zshenv" "$HOME/.zshenv"
```

To run the install script for a specific tool, you can run:
```sh
homerun install TOOLNAME
```

to run them all, do not provide a tool name:
```sh
homerun install
```

You can also put an install script in `$XDG_CONFIG_HOME` directly.  This
will be called before all other install scripts and can therefore be used to
install global dependencies.  For instance:
```sh
# install brew
echo 'installing homebrew...'
ruby -e `curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install`

# install node
brew install node
```

To see what an install script will do, without doing it, run:
```sh
homerun dry
```

## bin directories
If you have scripts you keep under source control in the
config directory, you can put them under the tool's `bin/` directory.

For example, I keep `homerun` itself in my `$XDG_CONFIG_HOME`:

```
$XDG_CONFIG_HOME/
  homerun/
    bin/
      homerun
```

The initialisation script will automatically add every `bin/` directory
to your `$PATH` variable.

To enable this, add this to your shell's rc file:
```sh
source "$XDG_CONFIG_HOME/homerun/initialize"
```


## wrapping up

Concretely my `$XDG_CONFIG_HOME` looks like this:

```
$XDG_CONFIG_HOME/
  install
  git/
    config
    ignore
  homerun/
    bin/
      homerun
  vim/
    include
    install
    vimrc
    vimfiles/
  zsh/
    .zprofile
    .zshrc
    functions/
    install
    zshenv
```


# Installation & Usage

## New repository

To initialize an empty dotfile repository and start using it:

```sh
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
mkdir -pv "$XDG_CONFIG_HOME"
git clone https://github.com/romeovs/homerun.git "$XDG_CONFIG_HOME/homerun"
source "$XDG_CONFIG_HOME/homerun/initialize"

cd "$XDG_CONFIG_HOME"
git init
echo homerun/ > .gitignore
```

This will:

  - set the `XDG_CONFIG_*` variables
  - create the config folder
  - fetch homerun
  - initialize homerun, so you can start using it
  - create a git repository for your dotfiles
  - make sure you don't add `homerun` stuff to this repository

Note that this is only one way to set up version control for your dotfiles,
some might want to split up the repo and keep a repo for each tool.  `homerun`
currently does not support profiles, configuration groups or anything of the sort.

If you do not have git installed, you can also use:
```sh
mkdir -pv "$XDG_CONFIG_HOME/homerun"
cd "$XDG_CONFIG_HOME/homerun"
curl -Lk https://github.com/romeovs/homerun/archive/master.tar.gz | tar zx --strip=1
```

To get started very quickly:
```sh
export XDG_CONFIG_HOME="$HOME/.config"
curl -s https://raw.githubusercontent.com/romeovs/homerun/master/setup.sh | sh
```
if you do not set the `$XDG_CONFIG_HOME`, the install script will fall back to
`$HOME/.install`.


## Using dotfiles from a repo

To use an existing dotfile repo, and start using `homerun`:

```sh
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
git clone https://github.com/username/dotfiles.git "$XDG_CONFIG_HOME"
git clone https://github.com/romeovs/homerun.git "$XDG_CONFIG_HOME/homerun"
source "$XDG_CONFIG_HOME/homerun/initialize"
homerun install
```

This will:

  - set the `XDG_CONFIG_*` variables
  - create the config folder and pull your config files into it
  - install and initialize homerun
  - run config install scripts in this order (if the files exist):
    - `$XDG_CONFIG_HOME/install`
    - `$XDG_CONFIG_HOME/**/install`

To have `homerun` at your fingertips at any time, add this to your
`.{z,ba,...}shrc` file:

```sh
source "$XDG_CONFIG_HOME/homerun/initialize"
```

also make sure the `$XDG_CONFIG_HOME` variable is set. For instance, I
put in my `.zshenv`:

```sh
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
```
