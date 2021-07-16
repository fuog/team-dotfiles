#!/bin/bash
#
# Fuog's dotfiles
#

# == Settings ===============
# use the command "dotfiles" to switch between these files
export DOTFILES_REPO=""
export DOTFILES_P10K=""
export DOTFILES_ADDITIONALS=""
export DOTFILES_VIMRC=""

# == loading ZSHRC ==========

source "${DOTFILES_REPO}/main-rc.zsh" \
    || echo "ERROR: Dotfiles main-rc not found"


