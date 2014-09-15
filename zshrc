if [[ -e $HOME/.dotfiles_location ]]; then
  export DOTFILES=$(readlink $HOME/.dotfiles_location)
else
  echo "~/.dotfiles_location not found, reinstall dotfiles"
fi

source $DOTFILES/rc
source $DOTFILES/zshuery/zshuery.sh
load_defaults
load_aliases

export COZY_PROJECTS_DIR="$HOME/repos"
export PATH="$COZY_PROJECTS_DIR/cozy-dotfiles:$PATH"

load_completion $DOTFILES/zshuery/completion $COZY_PROJECTS_DIR/cozy-dotfiles/completion
load_correction

prompt_char() {
    git branch >/dev/null 2>/dev/null && echo "`git branch | grep \* | cut -d\" \" -f2`$" && return
    echo '$'
}

prompts '%{$fg_bold[green]%}$(COLLAPSED_DIR)%{$reset_color%}$(virtualenv_info) %{$fg[yellow]%}$(prompt_char)%{$reset_color%} ' '%{$fg[red]%}$(ruby_version)  $(ruby_gemset)%{$reset_color%}'

chpwd() {
    update_terminal_cwd
}

PATH=$HOME/.rbenv/bin:/usr/local/sbin:$HOME/bin:/usr/local/bin:$PATH # Add Rbenv to PATH

export OPSCODE_USER=mgreensmith

# rbenv
export RBENV_ROOT=/usr/local/var/rbenv
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# heroku
export PATH="/usr/local/heroku/bin:$PATH"

export EC2_HOME="/usr/local/Cellar/ec2-api-tools/1.7.1.0/libexec"
export AWS_IAM_HOME="/usr/local/opt/aws-iam-tools/libexec"
export JAVA_HOME="$(/usr/libexec/java_home)"
export AWS_CREDENTIAL_FILE=$HOME/.aws-credentials-master

# python
source /usr/local/bin/virtualenvwrapper.sh

# local creds
source ~/.env-credentials
