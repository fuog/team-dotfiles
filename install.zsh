#!/bin/zsh
#
# Install dotfiles

# default path
DOTFILES_REPO="$HOME/git/dotfiles"

# override path by $1
if test -n "$1"; then
	if ! test -d "$(dirname "$1")"; then
		echo "ERROR: $1 is does not work as git folder"
		echo "       will use default $DOTFILES_REPO .."
		sleep 3 # give some time to cancle
	fi
	DOTFILES_REPO="$1"
fi

# Download dotfiles Repo
if ! test -d "$DOTFILES_REPO"; then
	git clone "https://github.com/fuog/dotfiles.git" "$DOTFILES_REPO"
fi

# remove zshrc links
test -L "$HOME/.zshrc" \
	&& rm "$HOME/.zshrc"
# move zshrc files
test -f "$HOME/.zshrc" \
	&& mv "$HOME/.zshrc" "$HOME/.zshrc.old"

# create new link
ln -s "$DOTFILES_REPO/main-rc.zsh" "$HOME/.zshrc"

echo "NOW do a :  exec \$SHELL"