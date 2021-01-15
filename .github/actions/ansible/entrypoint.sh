
#!/bin/sh

echo "$VAULT_PASS" > ./.vault_pass
ansible-playbook -i inventory.yml playbook.yml
shred ./.vault_pass