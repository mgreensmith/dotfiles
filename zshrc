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

prompts '%{$fg_bold[green]%}$(COLLAPSED_DIR)%{$reset_color%}$(virtualenv_info) %{$fg[yellow]%}$(prompt_char)%{$reset_color%} ' '%{$fg[red]%}$(ruby_version)@$(ruby_gemset)%{$reset_color%}'

chpwd() {
    update_terminal_cwd
}

PATH=$HOME/.rbenv/bin:/usr/local/sbin:$HOME/bin:/usr/local/bin:$PATH # Add Rbenv to PATH

export OPSCODE_USER=mgreensmith

export RBENV_ROOT=/usr/local/var/rbenv
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi