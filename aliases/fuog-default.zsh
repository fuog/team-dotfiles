#!/bin/bash

# replace the normal cat
command -v bat >/dev/null 2>&1 && alias cat=bat
command -v batcat >/dev/null 2>&1 && alias cat=batcat

# for resetting some audio stuff
command -v alsa >/dev/null 2>&1 && alias audio-reload="sudo alsa force-reload"

# Tarra-stuff
command -v terraform >/dev/null 2>&1 && alias tf="terraform"
command -v terragrunt >/dev/null 2>&1 && alias tg="terragrunt"

# simple aliases
# use '' for vars to be resolved at runtime
alias reload-shell='exec ${SHELL}'
