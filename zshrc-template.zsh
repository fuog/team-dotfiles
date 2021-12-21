#!/bin/zsh
# == MANAGED ZSHRC == by github.com/fuog/dotfiles ======= #
# Script sourcing check
test -z "$PS1" \
	&& echo -e "This script \033[00;31mshould be sourced\033[0m not executed" && exit 1

# Dotfiles configuration
export DOTFILES_REPO=""
export DOTFILES_ADDITIONALS=""
export DOTFILES_P10K=""
export DOTFILES_VIMRC=""
export DOTFILES_SCRIPTS=""

# execute some of the scripts
("${DOTFILES_REPO}/link-dotfiles.zsh" &) &> /dev/null
# Source zsh files
source "${DOTFILES_REPO}/main-rc.zsh" \
    || echo "ERROR: sourcing main-rc!"
source "${DOTFILES_REPO}/additionals/${DOTFILES_ADDITIONALS}" \
    || echo "Error: sourcing additionals!"
source "${DOTFILES_REPO}/manage-dotfiles.zsh" \
    || echo "Error: sourcing manage-dotfiles!"
source "${DOTFILES_REPO}/script-loader.zsh" \
    || echo "Error: sourcing additional scripts!"

# loading scripts as part of the dotfiles is not implemented for now

# The code below is respected but no managed by fuog/dotfiles
# == END OF MANAGED ZSHRC =============================== #
