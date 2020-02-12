#/bin/bash

CMD=gpg

if [ ! $(type -P $CMD) ]; then
  CMD=gpg2
fi

if [ ! $(type -P $CMD) ]; then
  echo "GPG not found"
  exit
fi

if [ ! -f vault-password.txt ]; then
  $CMD --decrypt-files .vault.gpg
fi

ansible-playbook $@