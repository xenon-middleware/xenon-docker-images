# following steps from https://slurm.schedmd.com/quickstart_admin.html
FROM munge

# become root user
USER root

# mysql-client      : needed for creating the accounting database
# libmysqlclient-dev: triggers installation of the MySQL accounting
#                     plugin during install of slurm;
# gcc               : to compile slurm from the GitHub source code
# make              : to be able to compile source code
# python            : slurm wants python
# libssl-dev        : triggers installation of crypto/openssl plugin for slurm
# libmunge-dev      : triggers installation of auth/munge plugin for slurm
# wget              : to be able to download said source code
# tar               : to extract the source code tar ball
RUN apt-get update && apt-get install -y mysql-client libmysqlclient-dev gcc make python libssl-dev libmunge-dev tar wget

# make a slurm user
RUN groupadd --system slurm && useradd --system --gid slurm --create-home slurm

# change user slurm's password to 'slurm'
RUN echo slurm:slurm | chpasswd

# make directory structure required by Slurm nodes
RUN mkdir -p /var/spool/slurmctld/state
RUN chown -R slurm:slurm /var/spool/slurmctld

# make slurm sysconfig directory
RUN mkdir -p /usr/local/etc/slurm

# make slurm logging directory
RUN mkdir -p /var/log/slurm
RUN chown -R slurm:slurm /var/log/slurm

# ADD slurm.cert from context to sysconfig directory
ADD slurm.cert /usr/local/etc/slurm/slurm.cert

# ADD slurm.key from context to sysconfig directory
ADD slurm.key /usr/local/etc/slurm/slurm.key

# set permissions on key file
RUN chmod 600 /usr/local/etc/slurm/slurm.key

# change ownership to the slurm user
RUN chown slurm:slurm /usr/local/etc/slurm/slurm.key

# ADD the supervisor configuration for each slurm service
ADD supervisor/slurmctld.conf /etc/supervisor/slurmctld.conf
ADD supervisor/slurmdbd.conf /etc/supervisor/slurmdbd.conf
ADD supervisor/slurmd-node-0.conf /etc/supervisor/slurmd-node-0.conf
ADD supervisor/slurmd-node-1.conf /etc/supervisor/slurmd-node-1.conf
ADD supervisor/slurmd-node-2.conf /etc/supervisor/slurmd-node-2.conf
ADD supervisor/slurmd-node-3.conf /etc/supervisor/slurmd-node-3.conf
ADD supervisor/slurmd-node-4.conf /etc/supervisor/slurmd-node-4.conf
ADD supervisor/slurm-nodes.conf /etc/supervisor/slurm-nodes.conf

# set workdirectory to something sane
WORKDIR /home/xenon/
