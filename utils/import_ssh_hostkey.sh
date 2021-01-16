#!/bin/sh

# import function library
PWD=$(dirname "$(readlink -f "$0")")
source "${PWD}/common.sh"

# change directory
OLD_DIR=${pwd}
cd "$PWD/.."

# get FQDN of host
read -r -p 'hostname: ' fqdn

# check hostname to be fqdn
host -N 0 "$fqdn" 2>&1>/dev/null \
  || die "$fqdn is not a vaild FQDN"

# add ssh public hostkey to inventory hosts 
ansible_ssh_hostkey_pub=$(ssh-keyscan -t ed25519 -H "$fqdn" 2>/dev/null )
yq e ".all[\"hosts\"][\"$fqdn\"].ansible_ssh_hostkey_pub=\"$ansible_ssh_hostkey_pub\"" -i "inventory.yml"

# change directory
cd $OLD_PWD
