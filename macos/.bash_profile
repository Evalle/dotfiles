# MacOs .bash_profile
# There are 3 different types of shells in bash: the login shell, normal shell
# and interactive shell. Login shells read ~/.profile and interactive shells
# read ~/.bashrc;
test -s ~/.alias && . ~/.alias || true

#and alias ls to GNUs alias
alias ls='gls --color=auto'
alias tmux='tmux -2'
alias ..='cd ..'
alias l='ls -l'
alias la='ls -al'
alias kc='kubectl'

# Exports
# ---------
export EDITOR=vim
PATH=$PATH:/Users/evgeny.shmarnev/.gem/ruby/2.4.0/bin/
export PATH
# export locale
export LANG=en_US.utf8

# Kubectl bash completion for MacOs
source $(brew --prefix)/etc/bash_completion
source <(kubectl completion bash)
# autocompletion for kubectl alias
source <(kubectl completion bash | sed s/kubectl/kc/g)
 
# Functions:
# ----------
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
              
# git branch
parse_git_branch() {
         git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

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

# added by travis gem
[ -f /home/evgeny/.travis/travis.sh ] && source /home/evgeny/.travis/travis.sh
PATH="$HOME/Library/Python/2.7/bin:$PATH"
