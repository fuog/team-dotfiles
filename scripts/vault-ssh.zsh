#!/bin/zsh
# Script execution check
test -n "$PS1" \
	&& echo -e "This script \033[00;31mshould be executed\033[0m not sourced!" && return
# =============================

# This script is for logging in to SSH-Hosts with Vault
# the only thing YOU need to provide is:
# - a logged in vault
# - the path for signing your cert at vault
#     VAULT_SSH_SIGNER

personal_pub="$HOME/.ssh/id_rsa.pub"
signed_cert="$HOME/.ssh/vault/signed-cert.pub"

# Check for ENV
if [ -z "$VAULT_SSH_SIGNER" ]; then
	# ELSE Using a Cloudintegration Default value
	VAULT_SSH_SIGNER="ssh-cloudintegration-signer/sign/cloud-admin"
fi

# create a folder for vault stuff
mkdir -p ~/.ssh/vault

# remove your 30-minutes-old $signed_cert (Default TTL of vault)
if [ -f "$signed_cert" ] && [ `stat --format=%Y $signed_cert` -le $(( `date +%s` - 1800 )) ]; then
	rm "$signed_cert" > /dev/null 2>&1
fi

# Get the cert if it does not exist
if ! [ -f "$signed_cert" ]; then
	vault write -field=signed_key "$VAULT_SSH_SIGNER" public_key="@$personal_pub" > "$signed_cert" || \
		( echo "!! Vault error! -- maybe you need to login first \n"; rm "$signed_cert" ; exit 1 )
	echo " ** Got a new signed Cert from Vault \n"
fi

# starting the SSH session with all other given parameters
ssh -i "$signed_cert" -i "$personal_pub" $@