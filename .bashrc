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

#PS1='[\u@\h \W]\$ '  # Default
#PS1='\[\e[1;36m\]\u@\h \W\$\[\e[0m\] '
#PS1='\[\e[0;33m\]\u\[\e[m\] \[\e[1;36m\]\w\[\e[m\] \[\e[0;35m\]\$\[\e[m\] '
#PS1="\[\033[37;1m\][\[\033[33;1m\]\u\[\033[37;1m\]@\[\033[32;1m\]\h\[\033[37;1m\]:\[\033[0;36m\]\w\[\033[37;1m\]]\[\033[m\]$ "
#PS1="\[\033[37;1m\][\[\033[m\]\u\[\033[37;1m\]@\[\033[m\]\h\[\033[37;1m\]:\[\033[m\]\w\[\033[37;1m\]]\[\033[m\]$ "
PS1='\[\e[0;33m\]\u\[\e[m\] \[\e[1;36m\]\w\[\e[m\] \[\e[0;35m\]\$\[\e[m\] '

# Monokai prompt
# Variables for prompt clarity

#LBLUE=$'\e[36;40m'
#PURPLE=$'\e[35;40m'
#GREEN=$'\e[32;40m'
#ORANGE=$'\e[33;40m'
#YELLOW=$'\e[37;40m'
#PINK=$'\e[31;40m'

#PS1='\n\n\[$PINK\]\u \[$LBLUE\]on \[$PURPLE\]\d \[$LBLUE\]at \[$ORANGE\]\@ \[$LBLUE\]in'
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
