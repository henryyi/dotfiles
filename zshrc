autoload -Uz compinit && compinit -u

if [[ "$TERM" == "dumb" ]]
then
  unsetopt zle
  unsetopt prompt_cr
  unsetopt prompt_subst
  if whence -w precmd >/dev/null; then
      unfunction precmd
  fi
  if whence -w preexec >/dev/null; then
      unfunction preexec
  fi
  PS1='$ '
  return
fi

autoload -Uz vcs_info
precmd_functions+=( vcs_info )
setopt prompt_subst

zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '*'
zstyle ':vcs_info:*' stagedstr '+'
zstyle ':vcs_info:git:*' formats '%F{200}[%b%u%c]%f'
zstyle ':vcs_info:*' enable git

PROMPT='%(?.%F{green}√.%F{red}?%?)%f %B%~%b $vcs_info_msg_0_ $ '

alias gcm="git checkout master"
alias gcmp="git checkout master; git pull;"
alias grm="git rebase master"
alias gic="git commit"
alias gca="git commit . --amend"
alias gup="git pull"
alias gis="git status"
alias gib="git branch"
alias gibra='gcm ; gib -D $(gib | grep "hyi" | tr -s "\n" " ")'
alias gibca='!git branch | grep -v "master" | xargs git branch -D'
alias gibcl='git switch master; for i in `git branch -l`; do git branch -d $i; done'
alias gco="git checkout"

alias ql="yarn refresh-graphql"
alias dql="bin/rails graphql:schema:dump SCHEMA_NAME=admin"

alias seedorder="NUM_ACO=0 rake dev:orders:generate_dummy_orders"
function seedaco() {
    if [[ $1 ]]; then
        export NUM_ACO=$1
    fi
    echo "seeding $NUM_ACO"
    rake dev:orders:generate_dummy_abandoned_checkouts
}

function gip() {
   read BRANCH <<< $(git status | awk '/On branch/ { print $3 }')
   echo
   read "doPush?Push ${BRANCH} to github?[n] "
   echo
   if [[ "$doPush" =~ ^[Yy]$ ]]; then
       git push -u origin "${BRANCH}"
   fi
}
