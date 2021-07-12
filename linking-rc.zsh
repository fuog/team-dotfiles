#!/bin/zsh
# Making sure that all the nice things we want
# are linked to $HOME

# Here we set defaults and source custom vars for P10K, ALIASES and VIMRC
ALIASES="fuog-default.zsh"; P10K="fuog-full.zsh"; VIMRC="fuog-default.vimrc"; ADDITIONALS="fuog-default.zsh"
test -f "$HOME/.zshrc_personal" && source "$HOME/.zshrc_personal"

# aliases linking
if ! [ "$(realpath "$HOME/.aliases")" = "$DOTFILES_REPO/aliases/$ALIASES" ]; then
    test -L "$HOME/.aliases" && rm "$HOME/.aliases"
    test -f "$HOME/.aliases" && mv "$HOME/.aliases" "$HOME/.aliases.old"
    test -f "$DOTFILES_REPO/aliases/$ALIASES" \
      && ln -s "$DOTFILES_REPO/aliases/$ALIASES" "$HOME/.aliases"
fi

# additional linking
if ! [ "$(realpath "$HOME/.zshrc_additionals")" = "$DOTFILES_REPO/additionals/$ADDITIONALS" ]; then
    test -L "$HOME/.zshrc_additionals" && rm "$HOME/.zshrc_additionals"
    test -f "$HOME/.zshrc_additionals" && mv "$HOME/.zshrc_additionals" "$HOME/.zshrc_additionals.old"
    test -f "$DOTFILES_REPO/additionals/$ADDITIONALS" \
      && ln -s "$DOTFILES_REPO/additionals/$ADDITIONALS" "$HOME/.zshrc_additionals"
fi

# p10k file linking
if ! [ "$(realpath "$HOME/.p10k.zsh")" = "$DOTFILES_REPO/p10k/$P10K" ]; then
    test -L "$HOME/.p10k.zsh" && rm "$HOME/.p10k.zsh"
    test -f "$HOME/.p10k.zsh" && mv "$HOME/.p10k.zsh" "$HOME/.p10k.zsh.old"
    test -f "$DOTFILES_REPO/p10k/$P10K" \
      && ln -s "$DOTFILES_REPO/p10k/$P10K" "$HOME/.p10k.zsh"
fi

# .vimrc file linking
if ! [ "$(realpath "$HOME/.vimrc")" = "$DOTFILES_REPO/p10k/$P10K" ]; then
    test -f "$HOME/.vimrc" && mv "$HOME/.vimrc" "$HOME/.vimrc.old"
    test -L "$HOME/.vimrc" && rm "$HOME/.vimrc"
    test -f "$DOTFILES_REPO/vimrc/$VIMRC" \
      && ln -s "$DOTFILES_REPO/vimrc/$VIMRC" "$HOME/.vimrc"
fi
