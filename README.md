

To initialize an empty dotfile repository:

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
