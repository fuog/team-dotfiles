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
mkdir -p "$HOME/.golib"
export GOPATH="$HOME/.golib"
export PATH="$PATH:$GOPATH/bin"

# replace the normal cat
command -v bat >/dev/null 2>&1 && alias cat=bat
command -v batcat >/dev/null 2>&1 && alias cat=batcat

# for resetting some audio stuff
command -v alsa >/dev/null 2>&1 && alias audio-reload="sudo alsa force-reload"

# https://bytexd.com/how-to-flush-dns-cache-in-ubuntu/
alias flush-dns="sudo killall -USR2 systemd-resolved"


# adding Azure autocompletion https://gastaud.io/en/article/azure-cli-autocomplete/
command -v az >/dev/null 2>&1 && \
  test -f "/etc/bash_completion.d/azure-cli" >/dev/null 2>&1 && \
    source /etc/bash_completion.d/azure-cli

# Tarra-stuff
command -v terraform >/dev/null 2>&1 && alias tf="terraform"
command -v terragrunt >/dev/null 2>&1 && alias tg="terragrunt"

# simple aliases
# use '' for vars to be resolved at runtime
alias reload-shell='exec ${SHELL}'

# Autoinstall kubeseal if not present
if ! command -v kubeseal >/dev/null 2>&1  && command -v kubectl >/dev/null 2>&1 && command -v go >/dev/null 2>&1  ; then
  GOOS="linux"
  GOARCH=$(go env GOARCH)
    wget "https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.18.2/kubeseal-${GOOS}-${GOARCH}"
  sudo install -m 755 kubeseal-$GOOS-$GOARCH /usr/local/bin/kubeseal
  unset GOOS GOARCH
fi

# adding kubeseal short for privat purpose
command -v kubeseal >/dev/null 2>&1 && kubectl config get-clusters | grep "Privat-K3s-cluster" >/dev/null 2>&1 \
  && alias kubeseal-priv="kubeseal --controller-name=sealed-secrets --controller-namespace=sealed-secrets --format yaml"

# install rbw
if ! command -v rbw >/dev/null 2>&1; then
  mkdir -p $HOME/.local/bin
  wget -q -O - "https://github.com/doy/rbw/releases/download/1.8.3/rbw_1.8.3_linux_amd64.tar.gz" \
    | tar -zxf - --exclude='completion' -C "$HOME/.local/bin"
fi

update_bin_completion rbw gen-completions zsh
update_bin_completion tkn completion zsh
update_bin_completion k3d completion zsh
update_bin_completion podman completion zsh
update_bin_completion kube-bench completion zsh
update_bin_completion pv-migrate completion zsh

# Note: first-time setup:
# 1. bw config server https://XYZ..
# 2. bw login xyz@foo.ch
# add bw_login
if command -v bw >/dev/null 2>&1 ; then
  function bw_login {
    if ! command -v jq >/dev/null 2>&1 ; then
      echo "Please install jq.. ⛔" ; return 1 ; fi
    if [ "$(bw status | jq -r '.status')" = "unlocked" ] ; then
      echo "already logged in 👍"
    else
      bw login 2>/dev/null
      new_BW_SESSION="$(bw unlock --raw)" && echo "Unlocked 👍"
      test -n "$new_BW_SESSION" && \
        export BW_SESSION="${new_BW_SESSION}"
      unset new_BW_SESSION
    fi
  }
fi

# Pipe to clipboard (apt install xclip)
command -v xclip >/dev/null 2>&1 && alias xclip="xclip -selection c"

# list manually installed packages
command -v xclip >/dev/null 2>&1 && \
  alias apt-installed-pkg="comm -23 <(apt-mark showmanual | sort -u) <(gzip -dc /var/log/installer/initial-status.gz | sed -n 's/^Package: //p' | sort -u)"

return 0