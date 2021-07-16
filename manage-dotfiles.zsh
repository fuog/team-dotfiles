#!/bin/zsh # script sourced

# == FUNCTIONS for management =============================
# All the functions below will be available within the
# user shell

dotfiles() {
  case $1 in
  repopath)
    if ! test -f "${2}/main-rc.zsh"; then
      echo -e "${RED}ERROR${RESTORE}: dotfiles repo not found at this location!"
      echo "       \"${2}/\""
      return 1
    else
      echo " ** Setting the new location to the dotfiles repo"
      DOTFILES_REPO="$(realpath "${2}")"
      export DOTFILES_REPO
      # using  s|foo|bar|  instead of normal s/foo/bar/ because of conflicts with dynamic path
      sed -i "s|export DOTFILES_REPO=\".*\"|export DOTFILES_REPO=\"${DOTFILES_REPO}\"|" "${HOME}/.zshrc" \
        || echo -e "${RED}ERROR${RESTORE}: updating the Settings failed!"
    fi
    ;;

  # TODO: This is not optimal maybe we should get rid of mostly repeated code in some time
  # TODO: Maybe we should check for the change that sed should do because this is now always errorcode 0 if the file is accessible
  additionals)
    if command -v fzf >/dev/null 2>&1 && test -z "${2}"; then
      # fzf present, no manual input
      DOTFILES_ADDITIONALS=$(ls -1 "${DOTFILES_REPO}/additionals" | grep ".zsh$" | \
        fzf --ansi --reverse --cycle --inline-info --header " == Select the additional-dotfile to use == " )
    elif test -n "${2}"; then
      DOTFILES_ADDITIONALS="${2}"
    else
      echo -e "${RED}ERROR${RESTORE}: you need to specify a filename or install fzf for selection"
      echo " ** Your options are:"
      ls -1 "${DOTFILES_REPO}/additionals" | grep ".zsh$"
      return
    fi
    if test -f "$DOTFILES_REPO/additionals/$DOTFILES_ADDITIONALS"; then
      echo " ** Setting ADDITIONALS-File to .zshrc"
      if ! sed -i "s/export DOTFILES_ADDITIONALS=\".*\"/export DOTFILES_ADDITIONALS=\"${DOTFILES_ADDITIONALS}\"/" "${HOME}/.zshrc"; then
        echo -e "${RED}ERROR${RESTORE}: updating the Settings failed!"
        return
      fi
      export DOTFILES_ADDITIONALS
    else
      echo -e "${RED}ERROR${RESTORE}: File \"additionals/$DOTFILES_ADDITIONALS\" not found!"
    fi
    ;;
  p10k)
    if command -v fzf >/dev/null 2>&1 && test -z "${2}"; then
      # fzf present, no manual input
      DOTFILES_P10K=$(ls -1 "${DOTFILES_REPO}/p10k" | grep ".zsh$" | \
        fzf --ansi --reverse --cycle --inline-info --header " == Select the p10k-style to use == ")
    elif test -n "${2}"; then
      DOTFILES_P10K="${2}"
    else
      echo -e "${RED}ERROR${RESTORE}: you need to specify a filename or install fzf for selection"
      echo " ** Your options are:"
      ls -1 "${DOTFILES_REPO}/p10k" | grep ".zsh$"
      return
    fi
    if test -f "$DOTFILES_REPO/p10k/$DOTFILES_P10K"; then
      echo " ** Setting P10K-File to .zshrc"
      echo "    you may need to    exec \$SHELL   for changes to take effect"
      if ! sed -i "s/export DOTFILES_P10K=\".*\"/export DOTFILES_P10K=\"${DOTFILES_P10K}\"/" "${HOME}/.zshrc"; then
        echo -e "${RED}ERROR${RESTORE}: updating the Settings failed!"
        return
      fi
      export DOTFILES_P10K
    else
      echo -e "${RED}ERROR${RESTORE}: File \"p10k/$DOTFILES_P10K\" not found!"
    fi
    ;;
  vimrc)
    if command -v fzf >/dev/null 2>&1 && test -z "${2}"; then
      # fzf present, no manual input
      DOTFILES_VIMRC=$(ls -1 "${DOTFILES_REPO}/vimrc" | \
        fzf --ansi --reverse --cycle --inline-info --header " == Select the VIMRC-file to use == ")
    elif test -n "${2}"; then
      DOTFILES_VIMRC="${2}"
    else
      echo -e "${RED}ERROR${RESTORE}: you need to specify a filename or install fzf for selection"
      echo " ** Your options are:"
      ls -1 "${DOTFILES_REPO}/vimrc"
      return 1
    fi
    if test -f "$DOTFILES_REPO/vimrc/$DOTFILES_VIMRC"; then
      echo "Setting VIMRC-File to .zshrc"
      if ! sed -i "s/export DOTFILES_VIMRC=\".*\"/export DOTFILES_VIMRC=\"${DOTFILES_VIMRC}\"/" "${HOME}/.zshrc"; then
        echo -e "${RED}ERROR${RESTORE}: updating the Settings failed!"
        return
      fi
      export DOTFILES_VIMRC
    else
      echo -e "${RED}ERROR${RESTORE}: File \"vimrc/$DOTFILES_VIMRC\" not found!"
    fi
    ;;

  install)
    echo " ** running the install script .."
    "${DOTFILES_REPO}/install.zsh"
    ;;

  update)
    echo " ** running the update script .."
    "${DOTFILES_REPO}/install.zsh"
    ;;

  scripts)
    echo " ** Not implemented"
    ;;

  *)
    echo "Usage: dotfiles [subcommand]"
    echo " ..  repopath <file>        specify the folder manually"
    echo " ..  additionals <file>     select or specify the file manually"
    echo " ..  p10k <file>            select or specify the file manually"
    echo " ..  vimrc <file>           select or specify the file manually"
#    echo " ..  scripts <file file2>   select or specify the files manually (multiple)"
#    echo "                            (not implemented for now)"
    echo " ..  install/update         just run the install/update script again"
    echo "                            (update repo && update .zshrc template)"
    ;;
  esac
}
