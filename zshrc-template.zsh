#!/bin/zsh
# == MANAGED ZSHRC == by github.com/fuog/dotfiles ======= #

# Dotfiles configuration
export DOTFILES_REPO=""
export DOTFILES_ADDITIONALS=""
export DOTFILES_P10K=""
export DOTFILES_VIMRC=""

# execute some of the scripts
("${DOTFILES_REPO}/link-dotfiles.zsh" &) &> /dev/null
# Source zsh files
source "${DOTFILES_REPO}/main-rc.zsh" \
    || echo "ERROR: sourcing main-rc!"
source "${DOTFILES_REPO}/additionals/${DOTFILES_ADDITIONALS}" \
    || echo "Error: sourcing additionals!"
source "${DOTFILES_REPO}/manage-dotfiles.zsh" \
    || echo "Error: sourcing manage-dotfiles!"

# loading scripts as part of the dotfiles is not implemented for now

# The code below is respected but no managed by fuog/dotfiles
# == END OF MANAGED ZSHRC =============================== #
