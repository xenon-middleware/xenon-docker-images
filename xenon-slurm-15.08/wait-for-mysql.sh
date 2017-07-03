#!/bin/sh

until mysqladmin -h mysql -pxenon-slurm-pw ping; do
  >&2 echo "Mysql is unavailable - sleeping"
  sleep 1
done

# TODO Need to run sacctmgr after mysql and slurmdbd are up and running
# sacctmgr -i add cluster mycluster
