#!/bin/zsh
# Script sourcing check
test -z "$PS1" \
	&& echo -e "This script \033[00;31mshould be sourced\033[0m not executed" && exit 1

#
# == aliasing all the scripts =================================
#

if [ -n "$DOTFILES_SCRIPTS" ]; then
    # do a loop over all scriptnames within $DOTFILES_SCRIPTS
    eval "DOTFILES_SCRIPTS=($DOTFILES_SCRIPTS)"
    for scriptname in ${DOTFILES_SCRIPTS[@]} ; do
        # check for existence
        if test -f "${DOTFILES_REPO}/scripts/${scriptname}"; then
            # check for execution-script
            # TODO: find a better way to to destinguish between sourcing and execution
            # is executable AND contains text "exec"
            if ls -l "${DOTFILES_REPO}/scripts/${scriptname}" | awk '{ print $1 }' | grep 'x' >/dev/null 2>&1 \
                && head -n3 < "${DOTFILES_REPO}/scripts/${scriptname}" | grep "exec"  >/dev/null 2>&1 ; then

                # creating alias name from scriptname
                script_alias="$(echo "${scriptname}" | cut -d. -f1)"

                # creating alias for script execution
                alias ${script_alias}="${DOTFILES_REPO}/scripts/${scriptname}"

             # contains text "sourc" OR is not executable
            elif head -n3 < "${DOTFILES_REPO}/scripts/${scriptname}"  | grep "sourc"  >/dev/null 2>&1 \
                || ! ls -l "${DOTFILES_REPO}/scripts/${scriptname}" | awk '{ print $1 }' | grep 'x' >/dev/null 2>&1 ; then

                # creating alias name from scriptname
                script_alias="$(echo "${scriptname}" | cut -d. -f1)"

                # creating alias for script sourcing
                alias ${script_alias}="source ${DOTFILES_REPO}/scripts/${scriptname}"
            else
                # creating alias name from scriptname
                script_alias="$(echo "${scriptname}" | cut -d. -f1)"

                # creating alias for script execution
                alias ${script_alias}="echo 'WARNING: script-loader error, should this script be sourced? asuming execution!'; \
                    ${DOTFILES_REPO}/scripts/${scriptname}"

            fi
        fi
    done
fi
