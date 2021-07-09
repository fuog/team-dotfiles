# Nathanael's personal zshrc
#

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
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# get zplug if missing
test -f "$HOME/.zplug/init.zsh" || git clone "https://github.com/zplug/zplug.git" "$HOME/.zplug"

# start loading zplug
source "$HOME/.zplug/init.zsh"

# Enable colors and change prompt:
autoload -U colors && colors

which code >/dev/null 2>&1 && \
  export EDITOR=code
mkdir -p "$HOME/.golib"
export GOPATH="$HOME/.golib"
export PATH="$PATH:$GOPATH/bin"

# The following lines were added by compinstall
zstyle :compinstall filename "$HOME/.zshrc"

# End of lines added by compinstall
source "$HOME/.zplug/init.zsh"

# plugin self management
zplug 'zplug/zplug', hook-build:'zplug --self-manage'
# Theme for zsh, best font to use is "hack nerd font" see https://www.nerdfonts.com
zplug "romkatv/powerlevel10k", from:github, depth:1, as:theme
# never load the ssh-agent if we are on a remote connection
if [ -z "$SSH_CLIENT" ] ; then
  zplug "bobsoppe/zsh-ssh-agent", from:github, depth:1, use:"ssh-agent.zsh"
fi

zplug "zsh-users/zsh-syntax-highlighting", from:github, depth:1, at:v0.7.1


# check first if grc does exist
if which grc >/dev/null 2>&1 ;then
  zplug "garabik/grc", from:github, depth:1, use:"grc.zsh", hook-load:"unset -f kubectl"
fi
# needs: go installed, gopath set, gopath/bin in $PATH
which fzf >/dev/null 2>&1 || go get github.com/junegunn/fzf
  zplug "junegunn/fzf", from:github, depth:1, use:"shell/*.zsh"

zplug "zsh-users/zsh-history-substring-search", from:github, defer:1, depth:1, use:"zsh-history-substring-search.zsh"
  # ^[[A was not possible somehow, but with ctrl it was. this method works in any case
  bindkey "$terminfo[kcuu1]" history-substring-search-up
  bindkey "$terminfo[kcud1]" history-substring-search-down

zplug "MenkeTechnologies/zsh-expand", defer:2, from:github, use:"zsh-expand.plugin.zsh"

# Conditional kubectl plugins: add kubectx and kubens, makes autocompletion for kubectl and some fixes to make it work without oh-my-zsh
if command -v kubectl >/dev/null 2>&1 ; then
  zplug "unixorn/kubectx-zshplugin", from:github, depth:1, use:"kubectx.plugin.zsh"
fi
if command -v kubectl >/dev/null 2>&1 ; then
  zplug "Dbz/kube-aliases", from:github, use:"kube-aliases.plugin.zsh", hook-load:"export KALIAS='$ZPLUG_REPOS/Dbz/kube-aliases'; export KRESOURCES='$ZPLUG_REPOS/Dbz/kube-aliases/docs/resources'"
fi
if command -v minikube >/dev/null 2>&1 ; then
  source <(minikube completion zsh)
fi
## adding some completion details from ohmyzsh
zplug "ohmyzsh/ohmyzsh", depth:1, from:github, use:"lib/completion.zsh"

# Skip forward/back a word with CTRL-arrow
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
# adding backward-tab on menu completion
bindkey "^[[Z" reverse-menu-complete

# End of Zplug stuff
zplug load
zplug check --verbose

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f "$HOME/.p10k.zsh" ]] || source "$HOME/.p10k.zsh"

#
# === Personal Stuff ====
#

test -d "$HOME/.local/bin" && export PATH="$HOME/.local/bin:$PATH"
test -d "$HOME/.tfenv/bin" && export PATH="$HOME/.tfenv/bin:$PATH"
test -d "$HOME/.tgenv/bin" && export PATH="$HOME/.tgenv/bin:$PATH"

# Use VSCode for "kubectl edit ..." but only if kubectl and code do exist
which kubectl >/dev/null 2>&1 && \
  which code >/dev/null 2>&1 && \
    KUBE_EDITOR="code -w"; export KUBE_EDITOR

which helm >/dev/null 2>&1 && \
  source <(helm completion zsh)


autoload -U +X bashcompinit && bashcompinit
if which terraform >/dev/null 2>&1 ; then
  terraform_path=$(whereis terraform | awk '{print $NF }')
  complete -o nospace -C $terraform_path terraform tf
  # https://github.com/gruntwork-io/terragrunt/issues/689#issuecomment-822455663
  complete -W "$(terragrunt | grep -A123 "COMMANDS" | head -n-7 | grep '^   ' | awk '{ print $1 }' | grep -v '*' | xargs)" terragrunt tg
fi

# BEGIN ANSIBLE MANAGED BLOCK
# Created by markosamuli.gcloud Ansible role
if [ -d "$HOME/.google/google-cloud-sdk" ]; then
  export CLOUDSDK_ROOT_DIR="$HOME/.google/google-cloud-sdk"
  # Update PATH for the Google Cloud SDK.
  source $CLOUDSDK_ROOT_DIR/path.zsh.inc
  # Enable zsh completion for gcloud.
  source $CLOUDSDK_ROOT_DIR/completion.zsh.inc
fi
# END ANSIBLE MANAGED BLOCK

# add aliases
test -f "${HOME}/.aliases" && source "${HOME}/.aliases"

# adding DevOps-Tools rc file
test -f "${HOME}/.DevOpsTools/included_rc.sh" && source "${HOME}/.DevOpsTools/included_rc.sh"
# stuff from DevOpsTools
test -f "$HOME/GIT/oscf/stuff-to-source.source" && source "$HOME/GIT/oscf/stuff-to-source.source"
test -f "$HOME/git/oscf/stuff-to-source.source" && source "$HOME/git/oscf/stuff-to-source.source"


test -d "${HOME}/.krew" && export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
