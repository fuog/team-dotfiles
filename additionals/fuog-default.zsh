#!/bin/zsh
# Here we have all the stuff that will not
# in to the other categories

# Setting default editor
command -v vi >/dev/null 2>&1 && \
  export EDITOR=vi

# setting go-stuff
mkdir -p "$HOME/.golib"
export GOPATH="$HOME/.golib"
export PATH="$PATH:$GOPATH/bin"

# Use VSCode for "kubectl edit ..." but only if kubectl and code do exist
which kubectl >/dev/null 2>&1 && \
  which code >/dev/null 2>&1 && \
    KUBE_EDITOR="code -w"; export KUBE_EDITOR
