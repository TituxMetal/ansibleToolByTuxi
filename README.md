# **Ansible Tool By Tuxi**

"Ansible" roles and playbooks for installation, configuration, and reset for multi-server
provisioning and management.

# **Start up connection**

When connecting the first time, this prompt appear:

_This key is not known by any other names._

_Are you sure you want to continue connecting (yes/no/[fingerprint])?_

To not see this prompt we must first launch a command to add the fingerprint of each server to the
known_host file.

Repeat this command for each new hosts:

```bash
ssh-keyscan -H $hostName  >> .ssh/known_hosts
```

Change **$hostName** to your corresponding host name in the inventory file.

# **Folders structure**

The folders structure is organized as recommended in the [Ansible documentation]. Separating
variables declaration by group and host in folders, a folder for: playbooks, roles, rollbacks,
and encrypted variables.

# **_/group_vars_**

This directory contains the main variables for each group. These variables are used specifically for
servers in these groups. Variables declared in the all.yaml file are used for all groups or for
servers that do not belong to any group.

# **_/host_vars_**

This directory contains the main variables for each server in its own directory. The file named with
the server name is used for non-sensible variables. The file prefixed with 'vault\_', is used for
sensible variables that must be encrypted, like root password or database password...

# **_/playbooks/_**

This directory contains the playbooks for server installation, configuration and resets. Each
playbook is in a directory that contains a main playbook and its rollback counterpart:

- **init/init.yaml** -- Initial server setup (apt repos, packages, firewall, users, SSH hardening,
  automatic security upgrades, backup cleanup, timezone, hostname, logrotate, chrony, locales,
  exim, admin user)
- **init/rollback.yaml** -- Undo all init operations
- **init/clean-reset.yaml** -- Complete server reset (removes admin user and groups)
- **docker/install.yaml** -- Docker installation (repository, GPG key, packages)
- **docker/rollback.yaml** -- Complete Docker removal
- **webserver/mainServices.yaml** -- Deploy main web services (Fail2ban container, firewall rules)
- **webserver/rollback.yaml** -- Rollback main web services
- **webserver/utils.yaml** -- Deploy utility services (Docker networks, Nginx Proxy
  Manager, main site container)
- **webserver/rollbackUtils.yaml** -- Rollback utility services
- **arcane/install.yaml** -- Deploy the Arcane manager and its agents
- **arcane/rollback.yaml** -- Unregister the environments and remove Arcane

# **_/roles/_**

This folder contains all the roles to do certain things, each role can have multiple features, is
divided into sub-roles that are reused in several playbooks. Each sub-roles has a particular
structure as described in the [Ansible documentation].

## _**apt**_

These roles are used for:

- install apt packages
- add apt keys
- add apt repository

## _**docker**_

These roles are used for:

- run a docker container
- pull an images with docker
- create a docker network

## _**dockerServices**_

These roles are used for:

- create the service data structure (directories, config files) from a GitHub repository

Note: Individual services (Fail2ban, Nginx Proxy Manager) are deployed using the generic
`docker/image` and `docker/container` roles with service-specific variables defined in group_vars.

## _**arcane**_

These roles are used for:

- bootstrap (resolve the enrollment token from the manager API)
- health (wait for the manager API)
- verify (check that an agent environment is connected)

## _**exim**_

These roles are used for:

- the configuration of Exim
- send an email

## _**firewall**_

These roles are used for:

- allow ports in firewall
- initialize the firewall

## _**system**_

These roles are used for all the system configuration like:

- chrony (time synchronization via NTP)
- hostname (hostname and /etc/hosts configuration)
- locales (system localization)
- cleanup (prune old Ansible backups and apt residues)
- logrotate (log rotation for Docker, Fail2ban, Nginx)
- sshConfig (SSH daemon hardening)
- timezone (system timezone)
- unattendedUpgrades (automatic security upgrades and their report)

## _**users**_

These roles are used for:

- add a user in one or more groups
- user admin configuration (bash, sudoers)
- create a group
- create a user

# **_/rollbacks/_**

This folder contains the roles to undo the things that were done before, each role can have multiple
features, is divided into sub-roles that are reused in several playbooks. Each sub-roles has a
particular structure as described in the [Ansible documentation].

## _**apt**_

These roles are used for:

- uninstall and purge a given list of apt packages
- remove a given apt key
- remove a given apt repository

## _**docker**_

These roles are used for:

- properly shut down a docker container
- remove an images with docker
- remove a docker network
- remove a docker volume
- remove docker data directories (optional purge)

## _**dockerServices**_

These roles are used for:

- remove the service data structure (directories, config files)

## _**exim**_

These roles are used for:

- reset exim configuration

## _**firewall**_

These roles are used for:

- deny a list of ports

## _**system**_

These roles are used for:

- reset ssh configuration
- remove the unattended upgrade configuration

## _**users**_

These roles are used for:

- remove a user from one or more groups
- remove user admin configuration (bash, sudoers)
- remove a group
- remove a user

## _**arcane**_

This role is used for:

- unregister the environment of a host from the Arcane manager

# **_.vault_**

This file contains the password of the vault to encrypt / decrypt files containing sensitive data.
It is used automatically by Ansible and can be disabled from the ansible.cfg file by removing the
"vault_password_file" line. **THIS FILE IS NOT ENCRYPTED AND MUST NOT BE PUBLIC**

# **_ansible.cfg_**

This file contains the Ansible configuration.

# **_hosts.yaml_**

This file contains all the hosts inventory. It is used automatically by Ansible and can be disabled
from the ansible.cfg file by removing the "inventory" line.

# **Usage on command line**

## Encrypt files

Encrypt all vault files present in the host_vars sub-directories, with this command:

```
ansible-vault encrypt host_vars/*/vault_*.yaml
```

Decrypt all vault files present in the host_vars sub-directories, with this command:

```
ansible-vault decrypt host_vars/*/vault_*.yaml
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

[ansible command documentation]:
  https://docs.ansible.com/ansible/latest/cli/ansible.html
  'Ansible Command documentation'
[ansible documentation]:
  https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html#directory-layout
  'Ansible documentation'
