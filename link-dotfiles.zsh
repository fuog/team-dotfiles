#!/bin/zsh
# script executed

# == File linking =========================================
# Most selected files can be sourced but these here are
# used by external tools and need to be sym-linked

# p10k file linking
if ! [ "$(realpath "$HOME/.p10k.zsh")" = "$DOTFILES_REPO/p10k/$DOTFILES_P10K" ]; then
    # remove if it is a link
    test -L "$HOME/.p10k.zsh" \
      && rm "$HOME/.p10k.zsh"
    # move to old if it is a file
    test -f "$HOME/.p10k.zsh" \
      && mv "$HOME/.p10k.zsh" "$HOME/.p10k.zsh.old"
    # Link if possible or throw an error
    test -f "$DOTFILES_REPO/p10k/$DOTFILES_P10K" \
      && ln -s "$DOTFILES_REPO/p10k/$DOTFILES_P10K" "$HOME/.p10k.zsh" \
      || echo "Error: \"$DOTFILES_REPO/p10k/$DOTFILES_P10K\" does not exist for linking \n       to \$HOME/.p10k.zsh"
fi

# vimrc file linking
if ! [ "$(realpath "$HOME/.vimrc")" = "$DOTFILES_REPO/vimrc/$DOTFILES_VIMRC" ]; then
    # remove if it is a link
    test -L "$HOME/.vimrc" \
      && rm "$HOME/.vimrc"
    # move to old if it is a file
    test -f "$HOME/.vimrc" \
      && mv "$HOME/.vimrc" "$HOME/.vimrc.old"
    # Link if possible or throw an error
    test -f "$DOTFILES_REPO/vimrc/$DOTFILES_VIMRC" \
      && ln -s "$DOTFILES_REPO/vimrc/$DOTFILES_VIMRC" "$HOME/.p10k.zsh" \
      || echo "Error: \"$DOTFILES_REPO/vimrc/$DOTFILES_VIMRC\" does not exist for linking \n       to \$HOME/.p10k.zsh"
fi
