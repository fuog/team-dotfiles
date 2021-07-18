#!/bin/zsh
# Script sourcing check
test -z "$PS1" \
	&& echo -e "This script \033[00;31mshould be sourced\033[0m not executed" && exit 1

echo "EXAMPLE1, sourced"
