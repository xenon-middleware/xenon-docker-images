#!/bin/bash
echo -e "starting services from start-services.sh\n"
/usr/local/bin/supervisord --configuration /home/xenon/supervisor/supervisord.conf

echo -e "status is:\n"
/usr/local/bin/supervisorctl --configuration /home/xenon/supervisor/supervisord.conf status

echo -e "starting munged\n"
/usr/local/bin/supervisorctl --configuration /home/xenon/supervisor/supervisord.conf start munged

echo -e "starting compute nodes\n"
/usr/local/bin/supervisorctl --configuration /home/xenon/supervisor/supervisord.conf start slurm-nodes:*


sleep 45

