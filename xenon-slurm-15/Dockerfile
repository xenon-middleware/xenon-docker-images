FROM nlesc/xenon-phusion-base
MAINTAINER Stefan Verhoeven "s.verhoeven@esciencecenter.nl"

# install Slurm batch scheduler v15.08 using the package manager
RUN apt-get update && \
apt-get install -y slurm-llnl slurmdbd mysql-client && \
apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# So we'll have multiple slurm components that need to communicate. Authentication
# mechanism is set to 'AuthType=auth/munge' (see ./etc/slurm.conf and https://dun.github.io/munge/), so we need
# to provide a digital signature, munge.key
ADD munge.key /etc/munge/munge.key

# change permission for MUNGE
RUN mkdir /var/run/munge && \
chmod 600 /etc/munge/munge.key && \
chown root.root /var/lib/munge /etc/munge /var/log/munge

# copy start-stop scripts for the slurm services from context to inside the
# Docker image
ADD service /etc/service

# Register cluster in slurmdbd
ADD wait-for-mysql.sh /etc/my_init.d/wait-for-mysql.sh

# configure Slurm
# Key was generated with openssl genrsa -out slurm.key 1024 && openssl rsa -in slurm.key -pubout -out slurm.cert
ADD etc /etc/slurm-llnl

# make directory structure required by Slurm nodes
RUN mkdir -p /var/spool/slurmctld/state && \
mkdir -p /var/spool/slurmd.node-0 && \
mkdir -p /var/spool/slurmd.node-1 && \
mkdir -p /var/spool/slurmd.node-2 && \
mkdir -p /var/spool/slurmd.node-3 && \
mkdir -p /var/spool/slurmd.node-4 && \

# create accounting file, change ownership to user 'slurm'
touch /var/spool/slurmctld/accounting.txt && \
chown slurm /var/spool/slurmctld/accounting.txt && \
chown slurm /var/spool/slurmctld/state && \
chown slurm /etc/slurm-llnl/slurm.key
 
# start the scripts we copied from the context to /etc/service
CMD ["/sbin/my_init"]
HEALTHCHECK --interval=1s CMD sinfo || exit 1
