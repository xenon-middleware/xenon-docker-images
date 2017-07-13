# following steps from https://slurm.schedmd.com/quickstart_admin.html
FROM munge

# become root user
USER root

# libmysqlclient-dev: triggers installation of the MySQL accounting
#                     plugin during install of slurm;
# gcc               : to compile slurm from the GitHub source code
# make              : to be able to compile source code
# python            : slurm wants python
# libssl-dev        : triggers installation of crypto/openssl plugin for slurm
# libmunge-dev      : triggers installation of auth/munge plugin for slurm
# wget              : to be able to download said source code
# tar               : to extract the source code tar ball
RUN apt-get update && apt-get install -y libmysqlclient-dev gcc make python libssl-dev libmunge-dev tar wget

#WORKDIR /usr/local
#
#RUN wget https://github.com/SchedMD/slurm/archive/slurm-17-02-6-1.tar.gz
#RUN tar -xvzf slurm-17-02-6-1.tar.gz
#
#WORKDIR /usr/local/slurm-slurm-17-02-6-1
#
#RUN ./configure --prefix=/usr/local --sysconfdir=/usr/local/etc/slurm --with-mysql_config=/usr/bin
#RUN make
#RUN make install

# make a slurm user
RUN groupadd --system slurm && useradd --system --gid slurm --create-home slurm

# change user slurm's password to 'slurm'
RUN echo slurm:slurm | chpasswd

# make directory structure required by Slurm nodes
RUN mkdir -p /var/spool/slurmctld/state
RUN chown -R slurm:slurm /var/spool/slurmctld

# make slurm sysconfig directory
RUN mkdir -p /usr/local/etc/slurm

# make slurm logging directory (use supervisor because that is the process that will start all the daemons/services)
RUN mkdir -p /var/log/slurm
RUN chown -R slurm:slurm /var/log/slurm

# ADD slurm.conf from context to sysconfig directory
#ADD slurm.conf /usr/local/etc/slurm/slurm.conf
#
# ADD slurmdbd.conf from context to sysconfig directory
#ADD slurmdbd.conf /usr/local/etc/slurm/slurmdbd.conf

# ADD slurm.cert from context to sysconfig directory
ADD slurm.cert /usr/local/etc/slurm/slurm.cert

# ADD slurm.key from context to sysconfig directory
ADD slurm.key /usr/local/etc/slurm/slurm.key

# set permissions on key file
RUN chmod 600 /usr/local/etc/slurm/slurm.key

# change ownership to the slurm user
RUN chown slurm:slurm /usr/local/etc/slurm/slurm.key


# ADD the supervisor configuration for each slurm service
ADD supervisor/slurmctld.conf /home/xenon/supervisor/slurmctld.conf
ADD supervisor/slurmdbd.conf /home/xenon/supervisor/slurmdbd.conf
ADD supervisor/slurmd-node-0.conf /home/xenon/supervisor/slurmd-node-0.conf
ADD supervisor/slurmd-node-1.conf /home/xenon/supervisor/slurmd-node-1.conf
ADD supervisor/slurmd-node-2.conf /home/xenon/supervisor/slurmd-node-2.conf
ADD supervisor/slurmd-node-3.conf /home/xenon/supervisor/slurmd-node-3.conf
ADD supervisor/slurmd-node-4.conf /home/xenon/supervisor/slurmd-node-4.conf
ADD supervisor/slurm-nodes.conf /home/xenon/supervisor/slurm-nodes.conf

# set workdirectory to something sane
WORKDIR /home/xenon/
