if [[ -e $HOME/.dotfiles_location ]]; then
  export DOTFILES=$(readlink $HOME/.dotfiles_location)
else
  echo "~/.dotfiles_location not found, reinstall dotfiles"
fi

source $DOTFILES/rc
source $DOTFILES/zshuery/zshuery.sh
load_defaults
load_aliases
load_completion $DOTFILES/zshuery/completion
load_correction

prompt_char() {
    git branch >/dev/null 2>/dev/null && echo "`git branch | grep \* | cut -d\" \" -f2`$" && return
    echo '$'
}

prompts '%{$fg_bold[green]%}$(COLLAPSED_DIR)%{$reset_color%}$(virtualenv_info) %{$fg[yellow]%}$(prompt_char)%{$reset_color%} ' '%{$fg[red]%}$(ruby_version)%{$reset_color%}'

chpwd() {
    update_terminal_cwd
}

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

export OPSCODE_USER=mgreensmith

PATH=$PATH:/usr/local/sbin
