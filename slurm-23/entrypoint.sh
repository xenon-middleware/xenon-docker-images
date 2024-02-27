#!/bin/bash

echo -e "\nstarting services..."
systemctl start mariadb
systemctl start slurmdbd
systemctl start sshd munge slurmctld  slurmrestd

# TODO run slurmd instances with systemd
echo -e "\nstarting compute nodes..."
/usr/sbin/slurmd -D -N node-0 > /var/log/slurmd-node-0.out.log 2> /var/log/slurmd-node-0.err.log &
/usr/sbin/slurmd -D -N node-1 > /var/log/slurmd-node-1.out.log 2> /var/log/slurmd-node-1.err.log &
/usr/sbin/slurmd -D -N node-2 > /var/log/slurmd-node-2.out.log 2> /var/log/slurmd-node-2.err.log &
/usr/sbin/slurmd -D -N node-3 > /var/log/slurmd-node-3.out.log 2> /var/log/slurmd-node-3.err.log &
/usr/sbin/slurmd -D -N node-4 > /var/log/slurmd-node-4.out.log 2> /var/log/slurmd-node-4.err.log &

sleep infinity
