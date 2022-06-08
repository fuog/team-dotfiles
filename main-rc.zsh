#!/bin/zsh
# Script sourcing check
test -z "$PS1" \
	&& echo -e "This script \033[00;31mshould be sourced\033[0m not executed" && exit 1
# ===========================
# Fuog's Main ZSHRC file
# ===========================
# Featrues implemented here should be okay to all who use the dotfiles
# everything that is not for all systems and all users should be in "additionals"

# Tools that should be installed for the full exp. : zsh, fzf, grc,

# Check if we can reach the internet with HTTPS
internet_access=true; timeout 1 curl https://ipinfo.io/ip >/dev/null 2>&1 || internet_access=false


# https://stackoverflow.com/questions/30840651/what-does-autoload-do-in-zsh
autoload -U +X bashcompinit && bashcompinit

# make sure further rc and dot files are linked correctly
test -f "$DOTFILES_REPO/linking-rc.zsh" \
  && source "$DOTFILES_REPO/linking-rc.zsh"

# if employeer-proxy; settings need to be set first
test -f /etc/profile.d/10_proxy_settings.sh && \
  source /etc/profile.d/10_proxy_settings.sh

# some history configurations
export HISTFILE=~/.zsh_history # Where it gets saved
export HISTSIZE=10000
export SAVEHIST=10000
setopt append_history # Don't overwrite, append!
setopt INC_APPEND_HISTORY # Write after each command
setopt hist_expire_dups_first # Expire duplicate entries first when trimming history.
setopt hist_fcntl_lock # use OS file locking
setopt hist_ignore_all_dups # Delete old recorded entry if new entry is a duplicate.
setopt hist_lex_words # better word splitting, but more CPU heavy
setopt hist_reduce_blanks # Remove superfluous blanks before recording entry.
setopt hist_save_no_dups # Don't write duplicate entries in the history file.
setopt share_history # share history between multiple shells
setopt HIST_IGNORE_SPACE # Don't record an entry starting with a space.

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
#if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ; fi

# adding some bin paths
test -d "$HOME/.local/bin" && export PATH="$HOME/.local/bin:$PATH"
test -d "$HOME/.tfenv/bin" && export PATH="$HOME/.tfenv/bin:$PATH"
test -d "$HOME/.tgenv/bin" && export PATH="$HOME/.tgenv/bin:$PATH"
test -d "${HOME}/.krew" && export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"


# Install zi
zi_home="${HOME}/.zi" && mkdir -p $zi_home
# Download the Repo if we have internet_access
test -d "${zi_home}/bin" || ( $internet_access && git clone https://github.com/z-shell/zi.git "${zi_home}/bin" )
# Do load the 'ZI' cmd if file does exist
test -f "${zi_home}/bin/zi.zsh" && \
  source "${zi_home}/bin/zi.zsh"
autoload -Uz _zi
(( ${+_comps} )) && _comps[zi]=_zi

# Enable colors and change prompt:
autoload -U colors && colors

# The following lines were added by compinstall
zstyle :compinstall filename "$HOME/.zshrc"
# Theme for zsh, example font to use is "hack nerd font" see https://www.nerdfonts.com
zi ice depth"1" && \
  zi light romkatv/powerlevel10k

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
test -f "$HOME/.p10k.zsh" && source "$HOME/.p10k.zsh"

# never load the ssh-agent if we are on a remote connection
test -z "$SSH_CLIENT" && (
  zi ice depth"1" pick"ssh-agent.zsh" && \
    zi light bobsoppe/zsh-ssh-agent )

# syntax-highlighting
zi ice depth"1" && \
  zi light z-shell/F-Sy-H

# check first if grc does exist
command -v grc >/dev/null 2>&1 && \
  zi ice depth"1" pick"grc.zsh" atload"command -v kubectl >/dev/null 2>&1 && unset -f kubectl >/dev/null 2>&1" && \
    zi light garabik/grc

# Load autocompletion and nice fzf key-bindings
zi ice depth"1" pick"/dev/null" multisrc"shell/{key-bindings,completion}.zsh" && \
  zi light junegunn/fzf

zi ice depth"1" && \
  zi light zsh-users/zsh-autosuggestions

# Adding the Substing-history lookup
zi ice depth"1" pick"zsh-history-substring-search.zsh" && \
  zi light zsh-users/zsh-history-substring-search
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

# zsh-expand
zi ice depth"1" pick"zsh-expand.plugin.zsh" && \
  zi light MenkeTechnologies/zsh-expand

# Conditional kubectl plugins: add kubectx and kubens, makes autocompletion for kubectl and some fixes to make the plugin work without oh-my-zsh
if command -v kubectl >/dev/null 2>&1 ; then
  source <(kubectl completion zsh)
  zi ice depth"1" pick"kubectx.plugin.zsh" && \
    zi light fuog/kubectx-zshplugin # made my own fork because the rpo owner wants to stay on SSH pull at submodules
  zi ice depth"1" pick"kube-aliases.plugin.zsh" at"fix_plugin" atload"export KALIAS='$ZI[PLUGINS_DIR]/Dbz---kube-aliases'; export KRESOURCES='$ZI[PLUGINS_DIR]/Dbz---kube-aliases/docs/resources'" && \
    zi light Dbz/kube-aliases && \
      complete -F __start_kubectl k >/dev/null 2>&1
  command -v kustomize >/dev/null 2>&1 \
    && source <(kustomize completion zsh)
  command -v kustomize >/dev/null 2>&1 \
    && source <(kustomize completion zsh)
fi


## adding some completion details from ohmyzsh
zi snippet OMZ::lib/completion.zsh
zi ice depth"1" && \
  zi light zchee/zsh-completions

# Adding the OMZ feature "clipboard/clippaste"
zi snippet OMZ::lib/clipboard.zsh

# Skip forward/back a word with CTRL-arrow
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# adding backward-tab on menu completion
bindkey "^[[Z" reverse-menu-complete


# Autocomplete Terraform and Terragrunt (they do not have somethig builtin)
# Tarra-stuff
command -v terraform >/dev/null 2>&1 && alias tf="terraform"
command -v terragrunt >/dev/null 2>&1 && alias tg="terragrunt"
if command -v terraform >/dev/null 2>&1 ; then
  terraform_path=$(whereis terraform | awk '{print $NF }')
  complete -o nospace -C $terraform_path terraform tf
  # https://github.com/gruntwork-io/terragrunt/issues/689#issuecomment-822455663
  command -v terragrunt >/dev/null 2>&1 && \
    complete -W "$(terragrunt | grep -A123 "COMMANDS" | head -n-7 | grep '^   ' | awk '{ print $1 }' | grep -v '*' | xargs)" terragrunt tg ; fi

# helm autocompletion
command -v helm >/dev/null 2>&1 \
  && source <(helm completion zsh)

# Disable globbing on the remote path. because scp is broken
# with zsh globbing-features
alias scp='noglob scp_wrap'
function scp_wrap {
  local -a args
  local i
  for i in "$@"; do case $i in
    (*:*) args+=($i) ;;
    (*) args+=(${~i}) ;;
  esac; done
  command scp "${(@)args}"
}
