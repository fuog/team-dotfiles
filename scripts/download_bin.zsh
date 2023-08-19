#!/bin/zsh
# Script execution check
test -n "$PS1" \
	&& echo -e "This script \033[00;31mshould be executed\033[0m not sourced!" && return

set -e

bin_target_folder="$HOME/.local/bin/"

# Check if $1 is set
if [ -z "$1" ]; then
    echo "Usage: $(basename "$0") <URL>"
    exit 1
fi

# Regular expression to validate URL format
url_regex="^(http|https)://[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}(#?\\S*)?$"

# Check if $1 matches the URL format
if ! [[ "$1" =~ $url_regex ]]; then
    echo "Invalid URL format: $1"
    exit 1
fi

echo "Valid URL: $1"
# Check if the URL contains ".tar.gz" extension
if [[ "$1" =~ \.tar\.gz$ ]]; then
    echo "URL contains .tar.gz extension."
	bin_name="$(echo "$1" | awk -F '/' '{print $NF}' | awk -F '_' '{print $1}')"
	echo "bin name is : $bin_name"
    curl -L "$1" | tar -xz --strip-components=1 -C "$bin_target_folder" "$bin_name"

    echo "Downloaded $bin_name to ${bin_target_folder}${bin_name}"
else
    echo "Not implemented: URL does not contain .tar.gz extension."
    exit 1
fi