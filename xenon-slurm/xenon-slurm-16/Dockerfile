FROM xenon-slurm-abstract

WORKDIR /usr/local

RUN wget https://github.com/SchedMD/slurm/archive/slurm-16-05-10-1.tar.gz
RUN tar -xvzf slurm-16-05-10-1.tar.gz

WORKDIR /usr/local/slurm-slurm-16-05-10-1

RUN ./configure --prefix=/usr/local --sysconfdir=/usr/local/etc/slurm --with-mysql_config=/usr/bin
RUN make
RUN make install

# ADD slurm.conf from context to sysconfig directory
ADD slurm.conf /usr/local/etc/slurm/slurm.conf

# ADD slurmdbd.conf from context to sysconfig directory
ADD slurmdbd.conf /usr/local/etc/slurm/slurmdbd.conf

# set the work directory to something sane
WORKDIR /home/xenon/

