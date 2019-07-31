#!/bin/bash
#
# This script installs the necessary tools and libraries to compile slurm, then
# downloads a slurm version, compiles and installs is, and removes any unnecessary
# code and tools afterwards.

set -e

cd /usr/local

apt-get update
apt-get --no-install-recommends install -y gcc make libssl-dev libmunge-dev tar wget

NAME=`basename -s .tar.gz $1`

wget -q https://github.com/SchedMD/slurm/archive/$1
tar -xf $1

cd /usr/local/slurm-$NAME

./configure --prefix=/usr/local --sysconfdir=/usr/local/etc/slurm
make -j ${nproc}
make install

cd /usr/local
rm -rf /usr/local/slurm-$NAME
rm /usr/local/$1

# NOTE: removing tar seems to break stuff.
apt-get purge -y gcc make wget libssl-dev libmunge-dev
apt autoremove -y
apt-get clean -y
