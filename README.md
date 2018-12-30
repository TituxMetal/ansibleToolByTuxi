# **Ansible Tool By Tuxi**
"Ansible" roles and playbooks for installation, configuration, and reset for multi-server provisioning and management.

# **Folders structure**
The folders structure is organized as recommended in the [Ansible documentation]. Separating variables declaration by group and host in folders, a folder for: playbooks, projects, roles, rollbacks, variables to protect specific to each project.

# ***/group_vars***
This directory contains the main variables for each group. These variables are used specifically for servers in these groups. Variables declared in the all.yaml file are used for all groups or for servers that do not belong to any group.

# ***/host_vars***
This directory contains the main variables for each server in its own directory. The file named with the server name is used for non-sensible variables. The file prefixed with 'vault_', is used for sensible variables that must be encrypted, like root password or database password...

# ***/playbooks/***
This directory contains the playbooks for server installation, configuration and resets. Each playbook is in a directory that contains two main files:

- one to do one or more things
- one to undo these same things

# ***/projects***
This directory contains the playbooks for projects deployment and reset. Each playbook is in a directory that contains two main files:

- one to deploy the project
- one to rollback the project

# ***/roles/***
This folder contains all the roles to do certain things, each role can have multiple features, is divided into sub-roles that are reused in several playbooks. Each sub-roles has a particular structure as described in the [Ansible documentation].

## *__apt__*
These roles are used for:
- install apt packages
- add apt keys
- add apt repository

## *__docker__*
These roles are used for:
- run a docker container
- pull an images with docker

## *__dockerServices__*
These roles are used for:
- configure and run the Fail2ban service container
- run the Letsencrypt service container
- run the Mongo service container and optionnally create a user and a database for projects
- run the Nginx proxy service container

## *__exim__*
These roles are used for:
- the configuration of Exim
- send an email

## *__firewall__*
These roles are used for:
- allow ports in firewall
- initialize the firewall

## *__system__*
These roles are used for all the system configuration like:
- hostname
- locales
- openNtp
- ssh
- timezone

## *__users__*
These roles are used for:
- add a user in one or more groups
- user admin configuration (bash, sudoers)
- create a group
- create a user

# ***/rollbacks/***

This folder contains the roles to undo the things that were done before, each role can have multiple features, is divided into sub-roles that are reused in several playbooks. Each sub-roles has a particular structure as described in the [Ansible documentation].

## *__apt__*
These roles are used for:
- uninstall and purge a given list of apt packages
- remove a given apt key
- remove a given apt repository

## *__docker__*
These roles are used for:
- properly shut down a docker container
- remove an images with docker

## *__dockerServices__*
These roles are used for:
- properly shut down the Fail2ban container and remove its image
- properly shut down the Letsencrypt container and remove its image
- properly shut down the Mongo container and remove its image
- properly shut down the Nginx proxy container and remove its image

## *__system__*
These roles are used for:
- reset ssh configuration

## *__users__*
These roles are used for:
- remove a user from one or more groups
- remove user admin configuration (bash, sudoers)
- remove a group
- remove a user

# ***/vault/***
This folder is a mirror of the projects folder. Each project has its own sensible variables file, that must be encrypted with the ansible-vault command.

# ***.vault***
This file contains the password of the vault to encrypt / decrypt files containing sensitive data. It is used automatically by Ansible and can be disabled from the ansible.cfg file by removing the "vault_password_file" line. **THIS FILE IS NOT ENCRYPTED AND MUST NOT BE PUBLIC**

# ***ansible.cfg***
This file contains the Ansible configuration.

# ***hosts.yaml***
This file contains all the hosts inventory. It is used automatically by Ansible and can be disabled from the ansible.cfg file by removing the "inventory" line.

# **Usage on command line**
## Encrypt files
Encrypt all files named "vault.yaml" present in all sub-directories of the ./vault folder, with this command:
```
ansible-vault encrypt ./vault/*/vault.yaml
```

Decrypt all files named "vault.yaml" present in all sub-directories of the ./vault folder, with this command:
```
ansible-vault decrypt ./vault/*/vault.yaml
```

Launch the init playbook with a custom variable that overwrite the default one, with this command:
```
ansible-playbook -e "ansible_user=customuser" playbooks/init/init.yaml
```

See the list of tasks that refers to the ssh tag in the init playbook, with this command:
```
ansible-playbook playbooks/init/init.yaml  --tags ssh --list-tasks
```

Launch a shell command to see memory usage on all servers in inventory, with this command:
```
ansible all -a "free -h"
```

For more usefull Ansible commands, read the [Ansible Command Documentation]


[Ansible Command Documentation]:https://docs.ansible.com/ansible/latest/cli/ansible.html "Ansible Command documentation"

[Ansible documentation]:https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html#directory-layout "Ansible documentation"
