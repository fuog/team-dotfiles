# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export http_proxy=http://webproxy.service.migros.cloud:30234
export https_proxy=http://webproxy.service.migros.cloud:30234
export HTTP_PROXY=http://webproxy.service.migros.cloud:30234
export HTTPS_PROXY=http://webproxy.service.migros.cloud:30234
export no_proxy=localhost,127.0.0.1,localaddress,migros.cloud,migros.ch,migros.net,cf.internal
export NO_PROXY=localhost,127.0.0.1,localaddress,migros.cloud,migros.ch,migros.net,cf.internal
# Do not store commands prefixed by a space in history
setopt HIST_IGNORE_SPACE

# Path to your oh-my-zsh installation.
export ZSH="~/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="agnoster"

ZSH_DISABLE_COMPFIX="true"
autoload -U compinit && compinit //override comp

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

source $HOME/.zplug/init.zsh
zplug "plugins/git",   from:oh-my-zsh
zplug "plugins/fzf", from:oh-my-zsh
zplug "plugins/man", from:oh-my-zsh
zplug "plugins/kubectl", from:oh-my-zsh
zplug "plugins/terraform", from:oh-my-zsh
zplug "plugins/colored-man-pages", from:oh-my-zsh
zplug "plugins/zsh-interactive-cd", from:oh-my-zsh
zplug "plugins/colorize", from:oh-my-zsh
zplug "plugins/ssh-agent", from:oh-my-zsh
zplug "hanjunlee/terragrunt-oh-my-zsh-plugin", from:github
zplug romkatv/powerlevel10k, as:theme, depth:1
zplug "zpm-zsh/ls"

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load --verbose

#Hook in direnv
#eval "$(direnv hook zsh)"

#Set base64 aliases for MacOS
alias base64encode="openssl base64 -e <<<"
alias base64decode="openssl base64 e <<<"

#History size
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

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh