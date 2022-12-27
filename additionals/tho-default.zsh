#!/bin/zsh
# Script sourcing check
test -z "$PS1" \
	&& echo -e "This script \033[00;31mshould be sourced\033[0m not executed" && exit 1

#Set base64 aliases for MacOS
alias base64encode="openssl base64 -e <<<"
alias base64decode="openssl base64 e <<<"

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

# replace the normal cat
command -v bat >/dev/null 2>&1 && alias cat=bat
command -v batcat >/dev/null 2>&1 && alias cat=batcat

# adding Azure autocompletion https://gastaud.io/en/article/azure-cli-autocomplete/
command -v az >/dev/null 2>&1 && \
  test -f "/etc/bash_completion.d/azure-cli" >/dev/null 2>&1 && \
    source /etc/bash_completion.d/azure-cli

# IaC-stuff
command -v terraform >/dev/null 2>&1 && alias tf="terraform"
command -v terragrunt >/dev/null 2>&1 && alias tg="terragrunt"

# simple aliases
# use '' for vars to be resolved at runtime
alias reload-shell='exec ${SHELL}'
