#!/bin/sh

# get stored GE hostname
export GE_HOST=$(cat /var/lib/gridengine/default/common/act_qmaster)
# Overwrite with current hostname
echo $HOSTNAME > /var/lib/gridengine/default/common/act_qmaster

# GE can not start in the foreground so use the rc scripts
/etc/init.d/gridengine-master start
/etc/init.d/gridengine-exec start

qconf -as $HOSTNAME
/bin/echo -e "group_name @allhosts\nhostlist $HOSTNAME" > /etc/gridengine/files/host_groups/allhosts
qconf -Mhgrp /etc/gridengine/files/host_groups/allhosts
qconf -ds $GE_HOST
qconf -dh $GE_HOST
qconf -de $GE_HOST
