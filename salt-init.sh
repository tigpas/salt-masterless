#!/bin/bash

set -e

if ! which salt-minion ; then
    if ! ( which wget && which gnupg && which git ); then
        apt-get update
        apt-get install -y wget gnupg git
    fi

    if [ ! -f /etc/apt/sources.list.d/saltstack.list ]; then
        wget -O - https://repo.saltstack.com/py3/debian/10/amd64/latest/SALTSTACK-GPG-KEY.pub | apt-key add -
        echo "deb http://repo.saltstack.com/py3/debian/10/amd64/latest buster main" > /etc/apt/sources.list.d/saltstack.list
    fi

    apt-get update
    apt-get install -y salt-minion python3-pip

    systemctl stop salt-minion
    systemctl disable salt-minion
fi

if [ ! -x /usr/local/bin/salt-masterless ]; then
    echo '/usr/bin/salt-call -c /opt/salt-masterless/etc --local $@' > /usr/local/bin/salt-masterless
    chmod 755 /usr/local/bin/salt-masterless
fi

mkdir -p /opt/salt-masterless/formulas
cd /opt/salt-masterless/formulas

for formula in {apache,docker,dovecot,postfix,mysql,samba,users}-formula salt-formula-linux; do
    if [ ! -d /opt/salt-masterless/formulas/${formula} ]; then
	URL="https://github.com/saltstack-formulas"
	[ "${formula}" == "salt-formula-linux" ] && URL="https://github.com/salt-formulas"
        git clone $URL/${formula}.git
    else
        cd $formula
        git pull
	cd ..
    fi
done
