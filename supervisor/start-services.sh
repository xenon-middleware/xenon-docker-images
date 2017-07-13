#!/bin/bash
echo -e "Starting services from start-services.sh...\n"
/usr/local/bin/supervisord --configuration /home/xenon/supervisor/supervisord.conf

echo -e "\nThese are the known services and their status:"
/usr/local/bin/supervisorctl --configuration /home/xenon/supervisor/supervisord.conf status

echo -e "\nstarting munged..."
/usr/local/bin/supervisorctl --configuration /home/xenon/supervisor/supervisord.conf start munged

echo -e "\nstarting slurmdbd..."
/usr/local/bin/supervisorctl --configuration /home/xenon/supervisor/supervisord.conf start slurmdbd

echo -e "\nstarting slurmctld..."
/usr/local/bin/supervisorctl --configuration /home/xenon/supervisor/supervisord.conf start slurmctld

echo -e "\nstarting compute nodes..."
/usr/local/bin/supervisorctl --configuration /home/xenon/supervisor/supervisord.conf start slurm-nodes:*

echo -e "\nstarting sshd..."
/usr/local/bin/supervisorctl --configuration /home/xenon/supervisor/supervisord.conf start sshd

sleep infinity

