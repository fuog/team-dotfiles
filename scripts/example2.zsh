#!/bin/zsh
# Script execution check
test -n "$PS1" \
	&& echo -e "This script \033[00;31mshould be executed\033[0m not sourced!" && return


echo "EXAMPLE2, executed"