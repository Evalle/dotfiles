# Sample .bashrc for SuSE Linux
# Copyright (c) SuSE GmbH Nuernberg

# There are 3 different types of shells in bash: the login shell, normal shell
# and interactive shell. Login shells read ~/.profile and interactive shells
# read ~/.bashrc; in our setup, /etc/profile sources ~/.bashrc - thus all
# settings made here will also take effect in a login shell.
#
# NOTE: It is recommended to make language settings in ~/.profile rather than
# here, since multilingual X sessions would not work properly if LANG is over-
# ridden in every subshell.

# Some applications read the EDITOR variable to determine your favourite text
# editor. So uncomment the line below and enter the editor of your choice :-)
#export EDITOR=/usr/bin/vim
#export EDITOR=/usr/bin/mcedit

# For some news readers it makes sense to specify the NEWSSERVER variable here
#export NEWSSERVER=your.news.server

# If you want to use a Palm device with Linux, uncomment the two lines below.
# For some (older) Palm Pilots, you might need to set a lower baud rate
# e.g. 57600 or 38400; lowest is 9600 (very slow!)
#

#export PILOTPORT=/dev/pilot
#export PILOTRATE=115200

test -s ~/.alias && . ~/.alias || true

#dircolors
if [ -f ~/.dir_colors ]; then
    eval `dircolors ~/.dir_colors`
fi
# Some aliases here
alias ibs='osc --apiurl https://api.suse.de'
alias ebs='osc -A https://api.opensuse.org'
#alias ebsb='osc -A https://api.opensuse.org ebs build --ccache --cpio-bulk-download --download-api-only'
alias tmux='tmux -2'
alias shellcheck='/home/evgeny/.cabal/bin/shellcheck'
alias cucumber='bundle exec cucumber'
alias ls='ls --color=auto'
alias ..='cd ..'
alias l='ls -l'

# use github-create function to creare github repository from command line
github-create() {
      repo_name=$1
     
      dir_name=`basename $(pwd)`
     
      if [ "$repo_name" = "" ]; then
        echo "Repo name (hit enter to use '$dir_name')?"
        read repo_name
      fi
     
      if [ "$repo_name" = "" ]; then
        repo_name=$dir_name
      fi
     
      username=`git config github.user`
      if [ "$username" = "" ]; then
        echo "Could not find username, run 'git config --global github.user <username>'"
        invalid_credentials=1
      fi
     
      token=`git config github.token`
      if [ "$token" = "" ]; then
        echo "Could not find token, run 'git config --global github.token <token>'"
        invalid_credentials=1
      fi
     
      if [ "$invalid_credentials" == "1" ]; then
        return 1
      fi
     
      echo -n "Creating Github repository '$repo_name' ..."
      curl -u "$username:$token" https://api.github.com/user/repos -d '{"name":"'$repo_name'"}' > /dev/null 2>&1
      echo " done."
     
      echo -n "Pushing local code to remote ..."
      git remote add origin git@github.com:$username/$repo_name.git > /dev/null 2>&1
      git push -u origin master > /dev/null 2>&1
      echo " done."
    }

# docker ip addresses
docker-ip() {
    docker ps | while read line; do
        if $(echo "$line" | grep -q 'CONTAINER ID'); then
            echo -e "IP ADDRESS\t$line"
        else
            CID=$(echo "$line" | awk '{print $1}');
            IP=$(docker inspect -f "{{ .NetworkSettings.IPAddress }}" "$CID");
            printf "%s\t%s\n" "${IP}" "${line}"
        fi
    done;
}
              

# Github's hub aliaases:
#eval "$(hub alias -s)"

# export /home/evgeny/bin directory
export PATH=$PATH:$HOME/bin
export EDITOR=vim

# export locale
export LANG=en_US.utf8

# ibs / obs setiings
export COMP_WORDBREAKS=${COMP_WORDBREAKS/:/}
alias isc="osc -A ibs"
alias oscb="osc build --ccache --cpio-bulk-download --download-api-only"
alias oscsd="osc service localrun download_files"

# git branch
#parse_git_branch() {
#         git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
#}

function _git_prompt() {
    local git_status="`git status -unormal 2>&1`"
    if ! [[ "$git_status" =~ Not\ a\ git\ repo ]]; then
        if [[ "$git_status" =~ nothing\ to\ commit ]]; then
            local ansi=42
        elif [[ "$git_status" =~ nothing\ added\ to\ commit\ but\ untracked\ files\ present ]]; then
            local ansi=43
        else
            local ansi=45
        fi
        if [[ "$git_status" =~ On\ branch\ ([^[:space:]]+) ]]; then
            branch=${BASH_REMATCH[1]}
            test "$branch" != master || branch=' '
        else
            # Detached HEAD.  (branch=HEAD is a faster alternative.)
            branch="(`git describe --all --contains --abbrev=4 HEAD 2> /dev/null ||
                echo HEAD`)"
        fi
        echo -n '\[\e[0;37;'"40"';1m\]'"$branch"'\[\e[0m\] '
    fi
}
function _prompt_command() {
    PS1="`_git_prompt`"'\[\033[38;5;14m\]\u\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]\[\033[38;5;3m\]\w\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]\[\033[38;5;14m\]>\[$(tput sgr0)\] '
    #PS1="`_git_prompt`"'\[\e[1;34m\]\w \$\[\e[0m\] '
}
PROMPT_COMMAND=_prompt_command

#PS1='[\u@\h \W]\$ '  # Default
#PS1='\[\e[1;36m\]\u@\h \W\$\[\e[0m\] '
#PS1='\[\e[0;33m\]\u\[\e[m\] \[\e[1;36m\]\w\[\e[m\] \[\e[0;35m\]\$\[\e[m\] '
#PS1="\[\033[37;1m\][\[\033[33;1m\]\u\[\033[37;1m\]@\[\033[32;1m\]\h\[\033[37;1m\]:\[\033[0;36m\]\w\[\033[37;1m\]]\[\033[m\]$ "
#PS1="\[\033[37;1m\][\[\033[m\]\u\[\033[37;1m\]@\[\033[m\]\h\[\033[37;1m\]:\[\033[m\]\w\[\033[37;1m\]]\[\033[m\]$ "
#PS1="\[\e[0;33m\]\u\[\e[m\] \[\e[1;36m\]\w\[\e[m\] \[\e[0;35m\]\$\[\e[m\]\$(parse_git_branch)\[\033[00m\] "
#PS1="\[\e[0;33m\]\u@\h \e[1;36m\W\[\]\033[32m\]\$(parse_git_branch)\[\033[00m\] $ "


# Monokai prompt
# Variables for prompt clarity

#LBLUE=$'\e[36;40m'
#PURPLE=$'\e[35;40m'
#GREEN=$'\e[32;40m'
#ORANGE=$'\e[33;40m'
#YELLOW=$'\e[37;40m'
#PINK=$'\e[31;40m'

#PS1='\n\n\[$PINK\]\u \[$LBLUE\]on \[$PURPLE\]\d \[$LBLUE\]at \[$ORANGE\]\@ \[$LBLUE\]'
#. ~/.bash_prompt

#Colored manpages
man() {
    env LESS_TERMCAP_mb=$'\E[01;31m' \
    LESS_TERMCAP_md=$'\E[01;38;5;74m' \
    LESS_TERMCAP_me=$'\E[0m' \
    LESS_TERMCAP_se=$'\E[0m' \
    LESS_TERMCAP_so=$'\E[38;5;246m' \
    LESS_TERMCAP_ue=$'\E[0m' \
    LESS_TERMCAP_us=$'\E[04;38;5;146m' \
    man "$@"
}

#the fuck alias

# specific for arch
export GEM_HOME=$(ruby -e 'print Gem.user_dir')
PATH=$PATH:/home/evgeny/.gem/ruby/2.3.0/bin/
export PATH

# added by travis gem
[ -f /home/evgeny/.travis/travis.sh ] && source /home/evgeny/.travis/travis.sh

# man pages highlight
export PAGER=most
