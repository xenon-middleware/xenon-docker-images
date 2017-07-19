#!/bin/bash
echo -e "Starting services from start-services.sh...\n"
/usr/local/bin/supervisord --configuration /etc/supervisord.conf

echo -e "\nThese are the known services and their status:"
/usr/local/bin/supervisorctl --configuration /etc/supervisord.conf status

echo -e "\nstarting sshd..."
/usr/local/bin/supervisorctl --configuration /etc/supervisord.conf start sshd

echo -e "\nstarting munged..."
/usr/local/bin/supervisorctl --configuration /etc/supervisord.conf start munged

until mysqladmin -h mysql -pxenon-slurm-pw ping; do
  >&2 echo "`date`: Mysql is unavailable - sleeping"
  sleep 1
done

echo -e "\nstarting slurmdbd..."
/usr/local/bin/supervisorctl --configuration /etc/supervisord.conf start slurmdbd

echo -e "\nstarting slurmctld..."
/usr/local/bin/supervisorctl --configuration /etc/supervisord.conf start slurmctld

echo -e "\nstarting compute nodes..."
/usr/local/bin/supervisorctl --configuration /etc/supervisord.conf start slurm-nodes:*

echo -e "\nStartup complete. These are the known services and their status:"
/usr/local/bin/supervisorctl --configuration /etc/supervisord.conf status

sleep infinity

