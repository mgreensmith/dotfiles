if [[ -e $HOME/.dotfiles_location ]]; then
  export DOTFILES=$(readlink $HOME/.dotfiles_location)
else
  export DOTFILES=$HOME/repos/dotfiles
  echo "~/.dotfiles_location not found, reinstall dotfiles"
fi

#for dir in $DOTFILES/bin/*(/); do
#  export PATH=$dir:$PATH
#done

source $HOME/repos/zshuery/zshuery.sh
load_defaults
load_aliases
load_lol_aliases
load_completion $HOME/repos/zshuery/completion
load_correction

prompt_char() { # by Steve Losh
    git branch >/dev/null 2>/dev/null && echo "`git branch | grep \* | cut -d\" \" -f2`$" && return
    hg root >/dev/null 2>/dev/null && echo '☿' && return
    echo '$'
}

prompts '%{$fg_bold[green]%}$(COLLAPSED_DIR)%{$reset_color%}$(virtualenv_info) %{$fg[yellow]%}$(prompt_char)%{$reset_color%} ' '%{$fg[red]%}$(ruby_version)%{$reset_color%}'

chpwd() {
    update_terminal_cwd
}
