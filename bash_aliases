[[ $PATH =~ .*:~/go/bin(:)? ]] || export PATH="$PATH:~/go/bin:~/gems/bin:~/bin"
export GEM_HOME="$HOME/gems"

alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

alias l='ls -al'
alias l.='ls -d .* --color=tty'
alias la='ls -AF'
alias ll='ls -l'
alias ls='ls --color=auto'

alias less='less -X'
alias which='/usr/bin/which -a'

alias gitai='git add -i'
alias gitb='git branch'
alias gitci='git commit'
alias gitco='git checkout'
alias gitd='git diff'
alias gitl='git log'
alias gitr='git rebase'
alias gits='git status'
alias gitsh='git show'
alias gitst='git stash'
alias gitsta='git stash apply'

alias svag='ssh vagrant@127.0.0.1 -p 2222'
alias mkc='microk8s kubectl'

ALLPODS=~/.kube/allpods
alias apods="mkc get pods -A -o wide --no-headers > $ALLPODS"
pod () {
    [ -r $ALLPODS ] || apods
    cat $ALLPODS | awk '{print $2}' | grep -o "^$1[^ ]*$2"
}

if [ -f ~/.bash_aliases.sec ]; then
    . ~/.bash_aliases.sec
fi
