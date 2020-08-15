Salt Masterless
===============

Use Salt without a Salt server. Put all your configuration into the git, and
distribute it though your git infrastructure.

How to use
----------

```
su -l -c "apt-get update; apt-get install git
  git clone https://github.com/tigpas/salt-masterless /opt/salt-masterless
  /opt/salt-masterless/salt-init.sh
  salt-masterless state.apply"
```
