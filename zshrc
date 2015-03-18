
if [[ -e $HOME/.dotfiles_location ]]; then
  export DOTFILES=$(readlink $HOME/.dotfiles_location)
else
  echo "~/.dotfiles_location not found, reinstall dotfiles"
fi
source $DOTFILES/rc
source $DOTFILES/zshuery.sh
load_defaults
load_aliases
export COZY_PROJECTS_DIR="$HOME/repos"

# rbenv
export RBENV_ROOT=/usr/local/var/rbenv
if which rbenv > /dev/null; then 
    eval "$(rbenv init --no-rehash -)"
    (rbenv rehash &) 2> /dev/null
fi

export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/sbin
export PATH=$PATH:$GOPATH/bin
export PATH="/opt/chefdk/bin:$PATH"
export PATH="/usr/local/heroku/bin:$PATH"
export PATH="$COZY_PROJECTS_DIR/cozy-dotfiles:$PATH"
export PATH=~/repos/chef-repo/bin:$PATH

load_completion $DOTFILES/zshuery/completion $COZY_PROJECTS_DIR/cozy-dotfiles/util/zsh_completion
load_correction

chpwd() {
    update_terminal_cwd
}

export OPSCODE_USER=mgreensmith

#export EC2_HOME="/usr/local/Cellar/ec2-api-tools/1.7.1.0/libexec"
#export AWS_IAM_HOME="/usr/local/opt/aws-iam-tools/libexec"
#export JAVA_HOME="$(/usr/libexec/java_home)"
#export AWS_CREDENTIAL_FILE=$HOME/.aws-credentials-master

# python
#source /usr/local/bin/virtualenvwrapper.sh

# local creds
source ~/.env-credentials

#export DOCKER_HOST=tcp://192.168.59.103:2376
#export DOCKER_CERT_PATH=/Users/matt/.boot2docker/certs/boot2docker-vm
#export DOCKER_TLS_VERIFY=1

#eval "$(hub alias -s)"
