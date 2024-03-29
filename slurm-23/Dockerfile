FROM ubuntu:22.04 as build

LABEL org.opencontainers.image.source https://github.com/xenon-middleware/xenon-docker-images
LABEL org.opencontainers.image.documentation https://github.com/xenon-middleware/xenon-docker-images/blob/master/slurm-23/README.md
LABEL org.opencontainers.image.licenses Apache-2.0

RUN apt update && apt install -y \
    build-essential fakeroot devscripts equivs \
    gcc make libssl-dev libmunge-dev tar wget \
    libfreeipmi-dev libreadline-dev \
    systemd libmariadb-dev libpmix-dev \
    libjwt-dev libhttp-parser-dev libjson-c-dev libyaml-dev

WORKDIR /src

ARG SLURM_VERSION=23.11.4

RUN wget https://download.schedmd.com/slurm/slurm-${SLURM_VERSION}.tar.bz2 && \
    tar -xf slurm-${SLURM_VERSION}.tar.bz2 --strip-components=1 && \
    rm slurm-${SLURM_VERSION}.tar.bz2

RUN mk-build-deps -t'apt-get -y -o Debug::pkgProblemResolver=yes --no-install-recommends' -i debian/control && \ 
    debuild -b -uc -us

FROM ubuntu:22.04

# install

ARG SLURM_VERSION=23.11.4

COPY --from=build \
     /slurm-smd_${SLURM_VERSION}-1_amd64.deb \
     /slurm-smd-client_${SLURM_VERSION}-1_amd64.deb \
     /slurm-smd-slurmd_${SLURM_VERSION}-1_amd64.deb \
     /slurm-smd-slurmdbd_${SLURM_VERSION}-1_amd64.deb \
     /slurm-smd-slurmrestd_${SLURM_VERSION}-1_amd64.deb \
     /slurm-smd-slurmctld_${SLURM_VERSION}-1_amd64.deb \
     /opt/

RUN apt update && apt install -y mariadb-server openssh-server python3 less wget /opt/*.deb
RUN useradd --system slurm

# slurmrestd can not run as root
RUN useradd --system slurmrest && \
    sed -i 's/# User=/User=slurmrest/' /usr/lib/systemd/system/slurmrestd.service && \
    sed -i 's/# Group=/Group=slurmrest/' /usr/lib/systemd/system/slurmrestd.service && \
    mkdir /usr/com && chown slurmrest /usr/com

COPY slurmd*.service /usr/lib/systemd/system/

# systemd 
# from https://github.com/gdraheim/docker-systemctl-replacement
RUN wget -O /usr/local/bin/systemctl.py https://github.com/gdraheim/docker-systemctl-replacement/raw/master/files/docker/systemctl3.py && \
    chmod +x /usr/local/bin/systemctl.py && \
    rm /usr/bin/systemctl && \
    ln -s /usr/local/bin/systemctl.py /usr/bin/systemctl

# Configure

COPY slurm.conf /etc/slurm/
COPY --chmod=600 --chown=slurm:nogroup slurmdbd.conf cgroup.conf /etc/slurm/
COPY --chmod=400 --chown=slurm:nogroup jwt_hs256.key /etc/slurm/

RUN mkdir -p /var/spool/slurm/state \
    /var/spool/slurm/slurmd.node-0 \
    /var/spool/slurm/slurmd.node-1 \
    /var/spool/slurm/slurmd.node-2 \
    /var/spool/slurm/slurmd.node-3 \
    /var/spool/slurm/slurmd.node-4 \
    /var/log/slurm && \
    chown -R slurm:nogroup /var/spool/slurm /var/log/slurm && \
    mkdir -p /var/lib/mysql /run/mysqld; \
	chown -R mysql:root /var/lib/mysql /var/run/mysqld; \
	chmod 755 /var//run/mysqld;

# Setup db for slurm accounting

ADD slurm_acct_db.sql /etc/slurm/
ADD mariadb.service /usr/lib/systemd/system/mariadb.service

RUN systemctl start mariadb && \
    mariadb < /etc/slurm/slurm_acct_db.sql && \
    systemctl stop mariadb

# xenon user
RUN useradd -U -s /bin/bash xenon

RUN echo xenon:javagat | chpasswd

USER xenon
WORKDIR /home/xenon

ADD --chown=xenon:xenon .ssh .ssh
RUN chmod 700 .ssh && \
    chmod 600 .ssh/id_rsa .ssh/id_dsa && \
    chmod 644 .ssh/authorized_keys .ssh/id_rsa.pub .ssh/id_dsa.pub

# Fixtures for xenon integration tests
RUN mkdir -p filesystem-test-fixture/links && \
echo "Hello World" > filesystem-test-fixture/links/file0 && \
touch filesystem-test-fixture/links/file1 && \
ln -s /home/xenon/filesystem-test-fixture/links/file0 /home/xenon/filesystem-test-fixture/links/link0 && \
ln -s /home/xenon/filesystem-test-fixture/links/file1 /home/xenon/filesystem-test-fixture/links/link1 && \
ln -s /home/xenon/filesystem-test-fixture/links/file2 /home/xenon/filesystem-test-fixture/links/link2 && \
ln -s /home/xenon/filesystem-test-fixture/links/link0 /home/xenon/filesystem-test-fixture/links/link3 && \
ln -s /home/xenon/filesystem-test-fixture/links/link2 /home/xenon/filesystem-test-fixture/links/link4 && \
ln -s /home/xenon/filesystem-test-fixture/links/link6 /home/xenon/filesystem-test-fixture/links/link5 && \
ln -s /home/xenon/filesystem-test-fixture/links/link5 /home/xenon/filesystem-test-fixture/links/link6

USER root
WORKDIR /root

# entrypoint

ADD entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
