# following steps from https://slurm.schedmd.com/quickstart_admin.html
FROM munge

# become root user
USER root

# libmysqlclient-dev: triggers installation of the MySQL accounting
#                     plugin during install of slurm;
# gcc               : to compile slurm from the GitHub source code
# git               : to be able to download said source code
# make              : to be able to compile source code
# python            : slurm wants python
RUN apt-get update && apt-get install -y libmysqlclient-dev gcc git make python

WORKDIR /usr/local

RUN git clone https://github.com/schedmd/slurm

WORKDIR /usr/local/slurm
RUN git checkout tags/slurm-17-02-6-1

RUN ./configure --prefix=/usr/local --sysconfdir=/usr/local/etc/slurm --with-mysql_config=/usr/bin
RUN make
RUN make install

# make a slurm user
RUN groupadd --system slurm && useradd --system --gid slurm --create-home slurm

# change user slurm's password to 'slurm'
RUN echo slurm:slurm | chpasswd

# FIXME not sure this is relevant
RUN mkdir -p /var/www/html/slurm
RUN cp -rf doc/html /var/www/html/slurm

# make slurm sysconfig directory
RUN mkdir -p /usr/local/etc/slurm

# make slurm logging directory (use supervisor because that is the process that will start all the daemons/services)
RUN mkdir -p /var/log/slurm
RUN chown -R slurm:slurm /var/log/slurm

# ADD slurm.conf from context to sysconfig directory
ADD slurm.conf /usr/local/etc/slurm/slurm.conf

# ADD the supervisor configuration for each slurm service
ADD supervisor/slurmctld.conf /home/xenon/supervisor/slurmctld.conf
ADD supervisor/slurmdbd.conf /home/xenon/supervisor/slurmdbd.conf
ADD supervisor/slurmd-node-0.conf /home/xenon/supervisor/slurmd-node-0.conf
ADD supervisor/slurmd-node-1.conf /home/xenon/supervisor/slurmd-node-1.conf
ADD supervisor/slurmd-node-2.conf /home/xenon/supervisor/slurmd-node-2.conf
ADD supervisor/slurmd-node-3.conf /home/xenon/supervisor/slurmd-node-3.conf
ADD supervisor/slurmd-node-4.conf /home/xenon/supervisor/slurmd-node-4.conf
ADD supervisor/slurm-nodes.conf /home/xenon/supervisor/slurm-nodes.conf

