# following steps from https://slurm.schedmd.com/quickstart_admin.html
FROM lubuntu-munge

# become root user
USER root

# install package libmysqlclient-dev to trigger installation of the MySQL accounting
# plugin during install of slurm; install gcc to be able to compile slurm from the GitHub
# source code
RUN apt-get update && apt-get install -y libmysqlclient-dev gcc

WORKDIR /usr/local

RUN git clone https://github.com/schedmd/slurm

WORKDIR /usr/local/slurm
RUN git checkout tags/slurm-17-02-6-1

RUN ./configure --prefix=/usr/local --sysconfdir=/usr/local/etc --with-mysql_config=/usr/bin
RUN make
RUN make install


#RUN mkdir -p /etc/sysconfig/slurm
#RUN cp etc/init.d.slurm /etc/init.d/slurmd
#RUN chmod +x /etc/init.d/slurmd
#RUN cp -rf doc/html /var/www/html/slurm
#RUN chown -R apache:apache /var/www/html/slurm


# Add user 'slurm'; the --gecos information contains things like the user's full name,
# room number, etc. We don't need it here, so it's set to an empty string.
#RUN /usr/sbin/adduser --gecos "" slurm
# change user slurm's password to 'slurm'
#RUN echo slurm:slurm | chpasswd

# become user slurm
#USER slurm

# change into user slurm's home directory
#WORKDIR /home/slurm/

# Add the ssh configuration from the Docker context to inside the Docker container
# Note these keys should be different from the user xenon's SSH keys
#ADD ssh/id_rsa.pub /home/slurm/.ssh/authorized_keys


