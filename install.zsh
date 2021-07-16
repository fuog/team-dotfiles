#!/bin/zsh
#
# Install dotfiles
RESTORE='\033[0m'; RED='\033[00;31m'; GREEN='\033[00;32m';

# default path
echo " ** Welcome a minimalistic ${GREEN}dotfiles installer${RESTORE}.."
# override path by $1
if test -n "$1"; then
	if ! test -d "$(dirname "$1")"; then
		echo -e "${RED}ERROR${RESTORE}: $1 is does not work as git folder, parent folder does not even exist"
		exit 1
	fi
	DOTFILES_REPO="$1"
# nothing was set
elif [ -z "$DOTFILES_REPO" ];then
	echo " ** \$DOTFILES_REPO is not set, will use default"
	DOTFILES_REPO="$HOME/git/dotfiles"
# DOTFILES_REPO was already set in environment
else
	echo " ** \$DOTFILES_REPO is already set in environment"
fi
echo " ** DOTFILES_REPO path is : $DOTFILES_REPO"
export DOTFILES_REPO

sleep 3 # give some time to cancel

# Download dotfiles Repo or update it
if ! test -d "$DOTFILES_REPO"; then
	git clone "https://github.com/fuog/dotfiles.git" "$DOTFILES_REPO"
else
	# check if the local repo is behind
	if git -C "$DOTFILES_REPO" status | head -n 2 | grep "branch is behind" ;then
		# check if the local is unclean
		if [ "$(git -C "${DOTFILES_REPO}" status --porcelain | wc -l)" != "0" ] \
			|| ! git -C "${DOTFILES_REPO}" diff --exit-code --quiet; then
			echo -e "${RED}ERROR${RESTORE}: your dotfiles-repo is behind and unclean.. this needs manual cleanup"
			exit 1
		else
			echo " ** The dotfiles-repo seams clean, pull updates now.."
			sleep 3 # give some time to cancel
			git -C "${DOTFILES_REPO}" pull
		fi
	else
		echo " ** The dotfiles-repo seams up-to-date"
	fi
fi


if grep "END OF MANAGED ZSHRC" "${HOME}/.zshrc" >/dev/null 2>&1 ; then
	echo " ** Your current \$HOME/.zshrc seams dotfiles-managed"
	echo " ** 	we will merge your own part with the currently"
	echo " ** 	managed zshrc"

	# get the linenumber to cut the original file
	cutline="$(cat "${HOME}/.zshrc" | grep -Fn "END OF MANAGED ZSHRC" | awk -F':' '{print $1}')"
	# make a temp file
	cp "${DOTFILES_REPO}/zshrc-template.zsh" "${HOME}/.zshrc.tmp"
	echo "${HOME}/.zshrc.tmp" # prevent line shift
	tail -n +$((cutline + 1)) "${HOME}/.zshrc" >> "${HOME}/.zshrc.tmp"
	mv "${HOME}/.zshrc.tmp" "${HOME}/.zshrc"

    # dotfiles scripts "${DOTFILES_REPO}" # not implemented

else
	echo " ** Your current \$HOME/.zshrc seams NOT dotfiles-managed"
	echo " ** 	we move it to $HOME/.zshrc.old"

	mv "${HOME}/.zshrc" "${HOME}/.zshrc.old"
	cp "${DOTFILES_REPO}/zshrc-template.zsh" "${HOME}/.zshrc"
	echo "" >> "${HOME}/.zshrc" # just to have e nice linebreak :P
fi

echo " ** write your configuration back to the managed part"
source "${DOTFILES_REPO}/manage-dotfiles.zsh"

# PATH
echo -n " .. 	" # just for readability
dotfiles repopath "${DOTFILES_REPO}"

# ADDITIONALS
if test -n "${DOTFILES_ADDITIONALS}"; then
	echo " ** 	using already selected additionals-file config"
	dotfiles additionals "${DOTFILES_ADDITIONALS}"
else
	echo " ** 	using default additionals-file \"fuog-default.zsh\""
	dotfiles additionals "fuog-default.zsh"
fi

# P10K
if test -n "${DOTFILES_P10K}"; then
	echo " ** 	using already selected p10k-file config"
	dotfiles p10k "${DOTFILES_P10K}"
else
	echo " ** 	using default p10k-file \"fuog-full.zsh\""
	dotfiles p10k "fuog-full.zsh"
fi

# VIMRC
if test -n "${DOTFILES_VIMRC}"; then
	echo " ** 	using already selected vimrc-file config"
	dotfiles vimrc "${DOTFILES_VIMRC}"
else
	echo " ** 	using default additionals-file \"fuog-default.zsh\""
	dotfiles vimrc "fuog-default.vimrc"
fi

    # dotfiles scripts "${DOTFILES_REPO}" # not implemented

exit 0

# create new link
ln -s "$DOTFILES_REPO/main-rc.zsh" "$HOME/.zshrc"
echo
echo "* ==== Finished installing dotfiles ==== *"
echo "NOW do :"
echo "1.  exec \$SHELL   # you may get some errors, thats okay"
echo "2.  zplug install   # maybe you need to allow some repo pull"
echo "3.  exec \$SHELL   # now we sould get the shell we want"
echo
