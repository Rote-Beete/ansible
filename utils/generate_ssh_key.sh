#!/bin/sh

# import function library
PWD=$(dirname "$(readlink -f "$0")")
source "${PWD}/common.sh"

# change directory
OLD_DIR=${pwd}
cd "$PWD/.."

# create tmp dir
tmp=$(mktemp -d)

# create fifo and hook ansible-vault to it
mkfifo -m 600 "${tmp}/key" "${tmp}/key.pub" \
	&& ansible_ssh_key=$(cat "${tmp}/key" | ansible-vault encrypt_string) \
	&& ansible_ssh_key_pub=$(cat "${tmp}/key.pub" | awk '{print $1" "$2" ci/cd@github"}') \
	&& yq e ".all.vars.ansible_ssh_key=\"$ansible_ssh_key\"" -i "inventory.yml" \
	&& yq e ".all.vars.ansible_ssh_key_pub=\"$ansible_ssh_key_pub\"" -i "inventory.yml" \
	&& sed -z 's/|-\n.*\!vault\ |/\!vault\ |/' -i "inventory.yml" \
	&& sed -z 's/\!\!str\ \!vault\ |/\!vault\ |/' -i "inventory.yml" \
	&& yq e '' -i "inventory.yml" &
# generate key and write to fifo
yes | ssh-keygen -t ed25519 -a 128 -q -N '' -f "${tmp}/key" 2>&1>/dev/null

#remove tmp dir
rm -rf "${tmp}"

# change directory
cd $OLD_PWD
