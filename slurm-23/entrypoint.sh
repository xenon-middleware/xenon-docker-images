#!/bin/bash

echo -e "\nstarting db..."
systemctl start mariadb munge sshd

echo -e "\nwaiting for db to start..."
sleep 1

echo -e "\nstarting slurmdbd..."

systemctl start slurmdbd

echo -e "\nwaiting for slurmdbd to start..."
sleep 1

echo -e "\nstarting slurm..."
systemctl start slurmctld slurmrestd

mkdir -p /sys/fs/cgroup/system.slice
echo -e "\nstarting compute nodes..."
systemctl start slurmd0 slurmd1 slurmd2 slurmd3 slurmd4

echo -e "\nEverthing is started"

sleep infinity
