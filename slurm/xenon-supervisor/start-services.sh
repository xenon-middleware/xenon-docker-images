#!/bin/bash
echo -e "Starting the supervisor daemon from start-services.sh...\n"
/usr/local/bin/supervisord --configuration /etc/supervisord.conf

echo -e "\nThese are the known services and their status:"
/usr/local/bin/supervisorctl --configuration /etc/supervisord.conf status

echo -e "\nstarting mysqld..."
/usr/local/bin/supervisorctl --configuration /etc/supervisord.conf start mysqld

echo -e "\nstarting munged..."
/usr/local/bin/supervisorctl --configuration /etc/supervisord.conf start munged

until mysqladmin -h localhost -pxenon-slurm-pw ping; do
  >&2 echo "`date`: Mysql is unavailable - sleeping"
  sleep 1
done

echo -e "\nstarting slurmdbd..."
/usr/local/bin/supervisorctl --configuration /etc/supervisord.conf start slurmdbd

echo -e "\nsleeping for a few seconds to avoid problems..."
sleep 5

# Create mycluster tables in mysql via slurmdbd
sacctmgr -i add Cluster mycluster

echo -e "\nstarting slurmctld..."
/usr/local/bin/supervisorctl --configuration /etc/supervisord.conf start slurmctld

echo -e "\nstarting compute nodes..."
/usr/local/bin/supervisorctl --configuration /etc/supervisord.conf start slurm-nodes:*

echo -e "\nstarting sshd..."
/usr/local/bin/supervisorctl --configuration /etc/supervisord.conf start sshd

echo -e "\nStartup complete. These are the known services and their status:"
/usr/local/bin/supervisorctl --configuration /etc/supervisord.conf status

sleep infinity

