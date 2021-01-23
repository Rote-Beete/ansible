#!/bin/sh

# import function library
PWD=$(dirname "$(readlink -f "$0")")
source "${PWD}/common.sh"

# change directory
OLD_DIR=${pwd}
cd "$PWD/.."

# generate and encrypt passwords
juntagrico_postgres_pass=$(tr -dc [:alnum:] < /dev/urandom | dd bs=42 count=1 2>/dev/null | ansible-vault encrypt_string) \
	&& yq e ".all.vars.juntagrico_postgres_pass=\"$juntagrico_postgres_pass\"" -i "inventory.yml" \
	&& sed -z 's/|-\n.*\!vault\ |/\!vault\ |/g' -i "inventory.yml" \
	&& sed -z 's/\!\!str\ \!vault\ |/\!vault\ |/g' -i "inventory.yml" \
	&& yq e '' -i "inventory.yml"
juntagrico_admin_pass=$(tr -dc [:alnum:] < /dev/urandom | dd bs=42 count=1 2>/dev/null | ansible-vault encrypt_string) \
	&& yq e ".all.vars.juntagrico_admin_pass=\"$juntagrico_admin_pass\"" -i "inventory.yml" \
	&& sed -z 's/|-\n.*\!vault\ |/\!vault\ |/g' -i "inventory.yml" \
	&& sed -z 's/\!\!str\ \!vault\ |/\!vault\ |/g' -i "inventory.yml" \
	&& yq e '' -i "inventory.yml"

# change directory
cd $OLD_PWD
