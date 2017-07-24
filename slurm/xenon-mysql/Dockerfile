FROM xenon-munge

USER root

RUN debconf-set-selections <<< 'mysql-server mysql-server/root_password password xenon-slurm-pw' && \
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password xenon-slurm-pw' && \
apt-get update &&\
apt-get install -y mysql-server

