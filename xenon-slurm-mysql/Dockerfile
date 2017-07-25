FROM nlesc/xenon-munge

USER root

RUN echo 'mysql-server mysql-server/root_password password xenon-slurm-pw' | debconf-set-selections

RUN echo 'mysql-server mysql-server/root_password_again password xenon-slurm-pw' | debconf-set-selections

RUN apt-get update && apt-get install -y mysql-server

# copy the mysql service configuration to /etc/supervisor directory
ADD supervisor/mysqld.conf /etc/supervisor/mysqld.conf
