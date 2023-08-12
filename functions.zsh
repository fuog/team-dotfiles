#!/bin/zsh

# This function adds auto-completions for a specified command to Zsh
# for Zinit plugin-manager.
# $1 command with completion-arguments eg. "kubectl completion zsh"
function update_bin_completion() {
    local cmd_name="${1}"
    ! command -v "$cmd_name" >/dev/null 2>&1 && return
    local ZINIT_HOME_DIR="$HOME/.local/share/zinit"
    local COMP_NOTES="$ZINIT_HOME_DIR/completion-notes"
    mkdir -p "$COMP_NOTES"
    # check input
    [[ $(echo "$@" | wc -w) -le 1 ]] && {
        echo "Input command with completion params 'kubectl completion zsh' !"
        return
    }
    # create Vars
    local cmd_path="$(whereis -b "$cmd_name" | awk '{print $2}')"
    local cmd_note_path="${COMP_NOTES}/_${cmd_name}.txt"
    local cmd_comp_path="$ZINIT_HOME_DIR/completions/_${cmd_name}"
    local cmd_sha="$(shasum "${cmd_path}")"

    if [[ -e "${cmd_note_path}" ]] && [[ "$(cat "$cmd_note_path")" == "$cmd_sha" ]]; then
        return 0 # SHA and File Path is still the same
        echo "Already added"

    else
        # File does not exist or SHA/Path is wrong
        local cmd_array=("$(dirname $cmd_path)/$@")
        bash -c "$cmd_array" >"$cmd_comp_path" || {
            echo "Fail during completion generation of $cmd_name"
            return
        }
        echo "$cmd_sha" >"$cmd_note_path"
        head "$cmd_comp_path" | grep "compdef" | grep "$cmd_name" >/dev/null 2>&1 || {
            echo "Fail during completion generation of $cmd_name, output is no valid compdef! showing file-head:"
            head "$cmd_comp_path"
            rm "$cmd_comp_path" "$cmd_note_path" # because we remove the failed files
            return
        }
        echo "Added ${cmd_name} to auto-completions in zinit"

        return 0
    fi
}