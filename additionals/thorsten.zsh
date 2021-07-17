#!/bin/zsh
# Script sourcing check
test -z "$PS1" \
	&& echo -e "This script \033[00;31mshould be sourced\033[0m not executed" && exit 1

#Set base64 aliases for MacOS
alias base64encode="openssl base64 -e <<<"
alias base64decode="openssl base64 e <<<"