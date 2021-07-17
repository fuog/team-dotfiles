#!/bin/zsh
# Here we have all the stuff that will not
# in to the other categories

# Setting default editor
command -v code >/dev/null 2>&1 && \
  export EDITOR="code --wait"

# Use VSCode for "kubectl edit ..." but only if kubectl and code do exist
which kubectl >/dev/null 2>&1 && \
  which code >/dev/null 2>&1 && \
    KUBE_EDITOR="code --wait"; export KUBE_EDITOR

# setting go-stuff
if command -v go >/dev/null 2>&1 ; then
  mkdir -p "$HOME/.golib"
  export GOPATH="$HOME/.golib"
  export PATH="$PATH:$GOPATH/bin" ; fi

# replace the normal cat
command -v bat >/dev/null 2>&1 && alias cat=bat
command -v batcat >/dev/null 2>&1 && alias cat=batcat

# for resetting some audio stuff
command -v alsa >/dev/null 2>&1 && alias audio-reload="sudo alsa force-reload"

# Tarra-stuff
command -v terraform >/dev/null 2>&1 && alias tf="terraform"
command -v terragrunt >/dev/null 2>&1 && alias tg="terragrunt"

# simple aliases
# use '' for vars to be resolved at runtime
alias reload-shell='exec ${SHELL}'
