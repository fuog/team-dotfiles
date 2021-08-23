#!/bin/zsh
# Script sourcing check
test -z "$PS1" \
	&& echo -e "This script \033[00;31mshould be sourced\033[0m not executed" && exit 1

# Here we have all the stuff that will not
# in to the other categories

# Setting default editor
command -v code >/dev/null 2>&1 && \
  export EDITOR="code --wait" || \
  export EDITOR="vi"

# Use VSCode for "kubectl edit ..." but only if kubectl and code do exist
which kubectl >/dev/null 2>&1 && \
  which code >/dev/null 2>&1 && \
    export KUBE_EDITOR="code --wait" || \
    export KUBE_EDITOR="vi"

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
command -v terragrunt >/dev/null 2>&1 && alias tg="terragrunt"GOOS=$(go env GOOS)                                                                                                                                                                   82.197.179.12    61%  
GOARCH=$(go env GOARCH)
wget https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.16.0/kubeseal-$GOOS-$GOARCH
sudo install -m 755 kubeseal-$GOOS-$GOARCH /usr/local/bin/kubeseal



# simple aliases
# use '' for vars to be resolved at runtime
alias reload-shell='exec ${SHELL}'

# Autoinstall kubeseal if not present b
if ! command -v kubeseal >/dev/null 2>&1 && ; then
  GOOS=$(go env GOOS) ; GOARCH=$(go env GOARCH)
  wget https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.16.0/kubeseal-$GOOS-$GOARCH
  sudo install -m 755 kubeseal-$GOOS-$GOARCH /usr/local/bin/kubeseal
  unset GOOS GOARCH
fi



