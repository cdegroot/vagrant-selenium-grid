#!/bin/sh

#
#  Setup apt
#
apt-get -q -y update

#
# Setup librarian-puppet
#

# Directory in which librarian-puppet should manage its modules directory
PUPPET_DIR=/etc/puppet/

# NB: librarian-puppet might need git installed. If it is not already installed
# in your basebox, this will manually install it at this point using apt or yum
GIT=/usr/bin/git
APT_GET=/usr/bin/apt-get
YUM=/usr/sbin/yum
if [ ! -x $GIT ]; then
    apt-get -q -y install git
fi

test -d $PUPPET_DIR || mkdir $PUPPET_DIR
cp /vagrant/puppet/Puppetfile $PUPPET_DIR
PATH=$PATH:/var/lib/gems/1.8/bin
if [ "$(gem search -i librarian-puppet)" = "false" ]; then
  gem install librarian-puppet
  cd $PUPPET_DIR && librarian-puppet install --clean
else
  cd $PUPPET_DIR && librarian-puppet update
fi

