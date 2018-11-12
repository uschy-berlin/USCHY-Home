# Ansible Role: Samba (SMB)

Installs Samba client and server for RHEL/CentOS.

## Requirements

Samba requires ports 137, 138, 139, 445 to be open to function properly. 

## Role Variables

None.

## Dependencies

None.

## Example Playbook

    - hosts: servers
      become: yes
      roles:
        - samba
