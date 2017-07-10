#!/bin/sh

until mysqladmin -h mysql -pxenon-slurm-pw ping; do
  >&2 echo "Mysql is unavailable - sleeping"
  sleep 1
done

/usr/sbin/munged
/usr/sbin/slurmdbd

# Create mycluster tables in mysql via slurmdbd
sacctmgr -i add cluster mycluster

killall slurmdbd
killall munged
