
if [[ -e $HOME/.dotfiles_location ]]; then
  export DOTFILES=$(readlink $HOME/.dotfiles_location)
else
  echo "~/.dotfiles_location not found, reinstall dotfiles"
fi
source $DOTFILES/rc
source $DOTFILES/zshuery.sh
load_defaults
load_aliases
export COZY_PROJECTS_DIR="$HOME/src/cozy"

# rbenv
export RBENV_ROOT=/usr/local/var/rbenv
if which rbenv > /dev/null; then 
    eval "$(rbenv init --no-rehash -)"
    (rbenv rehash &) 2> /dev/null
fi

# nvm
# https://github.com/lukechilds/zsh-nvm
export NVM_LAZY_LOAD=true
export NVM_AUTO_USE=true
source ~/.zsh-nvm/zsh-nvm.plugin.zsh

export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/sbin
export PATH=$PATH:$GOPATH/bin
export PATH="/opt/chefdk/bin:$PATH"
export PATH="/usr/local/heroku/bin:$PATH"
export PATH="$COZY_PROJECTS_DIR/cozy-dotfiles:$PATH"
export PATH=~/src/cozy/chef-repo/bin:$PATH
export PATH=~/bin:$PATH

load_completion $DOTFILES/completion $COZY_PROJECTS_DIR/cozy-dotfiles/util/zsh_completion
load_correction

chpwd() {
    update_terminal_cwd
}

export OPSCODE_USER=mgreensmith

# python
#source /usr/local/bin/virtualenvwrapper.sh

# local creds
source ~/.env-credentials

# local commands
source ~/.commands


eval "$(hub alias -s)"

export EDITOR=vim
