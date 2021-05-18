#!/bin/zsh
#
# Install dotfiles
#
# not ready jet
if [ -f "$HOME/.zshrc" ]; then mv "$HOME/.zshrc" "$HOME/.zshrc.old" fi
if [ -f "$HOME/.zshrc" ]; then mv "$HOME/.zshrc" "$HOME/.zshrc.old" fi

# get the current path for both shells
relativePath="${BASH_SOURCE[0]}"
if [ -z "$relativePath" ]; then
	# ZSH way of getting the same path
	relativePath="$0"
fi
fullPath = $(realpath "$relativePath")
repoPath = $(dirname "$fullPath")

ln -s "$fullPath/.zshrc" "$HOME/.zshrc"
ln -s "$fullPath/.aliases" "$HOME/.aliases"

#
# V I M stuff
#

mkdir -p "$HOME/.vim/color"
wget https://raw.githubusercontent.com/altercation/vim-colors-solarized/master/colors/solarized.vim -o .vim/colors/solarized.vim -q
