
IS_MAC=1


# Settings
autoload colors; colors;
load_defaults() {
    setopt auto_name_dirs
    setopt pushd_ignore_dups
    setopt prompt_subst
    setopt no_beep
    setopt auto_cd
    setopt multios
    setopt cdablevarS
    setopt transient_rprompt
    setopt extended_glob
    autoload -U url-quote-magic
    zle -N self-insert url-quote-magic
    autoload -U zmv
    bindkey "^[m" copy-prev-shell-word
    HISTFILE=$HOME/.zsh_history
    HISTSIZE=10000
    SAVEHIST=10000
    setopt hist_ignore_dups
    setopt hist_reduce_blanks
    setopt share_history
    setopt append_history
    setopt hist_verify
    setopt inc_append_history
    setopt extended_history
    setopt hist_expire_dups_first
    setopt hist_ignore_space
}

ruby_version() { rbenv version-name }

# Current directory in title
update_terminal_cwd() { print -Pn "\e]2;%~\a" }
        
# Prompt aliases for readability
USER_NAME='%n'
HOST_NAME='%m'
DIR='%~'
COLLAPSED_DIR() { # by Steve Losh
    echo $(pwd | sed -e "s,^$HOME,~,")
    local PWD_URL="file://$HOST_NAME${PWD// /%20}"
}

# Functions
prompts() {
    PROMPT=$1
    RPROMPT=$2
}

prompt_char() {
    git branch >/dev/null 2>/dev/null && echo "`git branch | grep \* | cut -d\" \" -f2`$" && return
    echo '$'
}

virtualenv_info() {
    [ $VIRTUAL_ENV ] && echo ' ('`basename $VIRTUAL_ENV`')'
}

prompts '%{$fg_bold[green]%}$(COLLAPSED_DIR)%{$reset_color%}$(virtualenv_info) %{$fg[yellow]%}$(prompt_char)%{$reset_color%} ' '%{$fg[red]%}$(ruby_version)  $(ruby_gemset)%{$reset_color%}'


last_modified() { # by Ryan Bates
    ls -t $* 2> /dev/null | head -n 1
}

ex() {
    if [[ -f $1 ]]; then
        case $1 in
          *.tar.bz2) tar xvjf $1;;
          *.tar.gz) tar xvzf $1;;
          *.tar.xz) tar xvJf $1;;
          *.tar.lzma) tar --lzma xvf $1;;
          *.bz2) bunzip $1;;
          *.rar) unrar $1;;
          *.gz) gunzip $1;;
          *.tar) tar xvf $1;;
          *.tbz2) tar xvjf $1;;
          *.tgz) tar xvzf $1;;
          *.zip) unzip $1;;
          *.Z) uncompress $1;;
          *.7z) 7z x $1;;
          *.dmg) hdiutul mount $1;; # mount OS X disk images
          *) echo "'$1' cannot be extracted via >ex<";;
    esac
    else
        echo "'$1' is not a valid file"
    fi
}

mcd() { mkdir -p "$1" && cd "$1"; }

pj() { python -mjson.tool } # pretty-print JSON
cj() { curl -sS $@ | pj } # curl JSON

md5() { echo -n $1 | openssl md5 /dev/stdin }
sha1() { echo -n $1 | openssl sha1 /dev/stdin }
sha256() { echo -n $1 | openssl dgst -sha256 /dev/stdin }
sha512() { echo -n $1 | openssl dgst -sha512 /dev/stdin }

urlencode() { python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1])" $1 }
urldecode() { python -c "import sys, urllib as ul; print ul.unquote_plus(sys.argv[1])" $1 }
path() { echo $PATH | tr ":" "\n" }

# Aliases
load_aliases() {
    alias ..='cd ..'
    alias ....='cd ../..'
    alias la='ls -la'
    if [[ $IS_MAC -eq 1 ]]; then
        alias ql='qlmanage -p 2>/dev/null' # OS X Quick Look
        alias oo='open .' # open current dir in OS X Finder
    fi
    alias clr='clear'
    alias s_http='python -m SimpleHTTPServer' # serve current folder via HTTP
    alias s_smtp='python -m smtpd -n -c DebuggingServer localhost:1025' # SMTP test server, outputs to console
    alias wget='wget --no-check-certificate'
    alias pinst='sudo python setup.py install && sudo rm -r build && sudo rm -r dist && sudo rm -r *egg-info' # install a Python package
    alias beep='echo -n "\a"'
    alias lst="ls -R | grep ":$" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/ /' -e 's/-/|/'"
}


# Completion
load_completion() {
    # http://www.reddit.com/r/commandline/comments/kbeoe/you_can_make_readline_and_bash_much_more_user/
    # https://wiki.archlinux.org/index.php/Zsh
    autoload -U compinit
    fpath=($* $fpath)
    fignore=(.DS_Store $fignore)
    compinit -i
    zmodload -i zsh/complist
    setopt complete_in_word
    setopt auto_remove_slash
    unsetopt always_to_end
    [[ -f ~/.ssh/known_hosts ]] && hosts=(`awk '{print $1}' ~/.ssh/known_hosts | tr ',' '\n' `)
    [[ -f ~/.ssh/config ]] && hosts=($hosts `grep '^Host' ~/.ssh/config | sed s/Host\ // | egrep -v '^\*$'`)
    [[ -f /var/lib/misc/ssh_known_hosts ]] && hosts=($hosts `awk -F "[, ]" '{print $1}' /var/lib/misc/ssh_known_hosts | sort -u`)
    zstyle ':completion:*' insert-tab pending
    zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
    highlights='${PREFIX:+=(#bi)($PREFIX:t)(?)*==31=1;32}':${(s.:.)LS_COLORS}}
    highlights2='=(#bi) #([0-9]#) #([^ ]#) #([^ ]#) ##*($PREFIX)*==1;31=1;35=1;33=1;32=}'
    zstyle -e ':completion:*' list-colors 'if [[ $words[1] != kill && $words[1] != strace ]]; then reply=( "'$highlights'" ); else reply=( "'$highlights2'" ); fi'
    unset highlights
    zstyle ':completion:*' completer _complete _match _approximate
    zstyle ':completion:*' squeeze-slashes true
    zstyle ':completion:*' expand 'yes'
    zstyle ':completion:*:match:*' original only
    zstyle ':completion:*:approximate:*' max-errors 1 numeric
    zstyle ':completion:*:hosts' hosts $hosts
    zstyle ':completion::complete:*' use-cache 1
    zstyle ':completion::complete:*' cache-path ./cache/
    zstyle ':completion:*:cd:*' ignore-parents parent pwd
    zstyle ':completion:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
    zstyle ':completion:*:*:*:processes' command "ps -u `whoami` -o pid,user,comm -w -w"

}

# Correction
load_correction() {
    setopt correct_all
    alias man='nocorrect man'
    alias mv='nocorrect mv'
    alias mysql='nocorrect mysql'
    alias mkdir='nocorrect mkdir'
    alias erl='nocorrect erl'
    alias curl='nocorrect curl'
    alias rake='nocorrect rake'
    alias make='nocorrect make'
    alias cake='nocorrect cake'
    alias lessc='nocorrect lessc'
    alias lunchy='nocorrect lunchy'
    SPROMPT="$fg[red]%R →$reset_color $fg[green]%r?$reset_color (Yes, No, Abort, Edit) "
}
