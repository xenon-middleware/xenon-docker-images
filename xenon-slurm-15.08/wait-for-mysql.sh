#!/bin/sh

until mysqladmin -h mysql -pxenon-slurm-pw ping; do
  >&2 echo "Mysql is unavailable - sleeping"
  sleep 1
done
