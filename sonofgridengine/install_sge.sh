#!/bin/bash
#
# This script downloads and installs son-of-gridengine

set -e

cd /var/tmp

wget -q https://arc.liv.ac.uk/downloads/SGE/releases/8.1.9/sge-common_8.1.9_all.deb
wget -q https://arc.liv.ac.uk/downloads/SGE/releases/8.1.9/sge_8.1.9_amd64.deb

#dpkg -i /var/tmp/sge-common_8.1.9_all.deb
#dpkg -i /var/tmp/sge_8.1.9_amd64.deb
apt install -y /var/tmp/sge-common_8.1.9_all.deb
apt install -y /var/tmp/sge_8.1.9_amd64.deb

rm -f /var/tmp/sge-common_8.1.9_all.deb
rm -f /var/tmp/sge-common_8.1.9_amd64.deb

apt autoremove -y
apt-get clean -y
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
