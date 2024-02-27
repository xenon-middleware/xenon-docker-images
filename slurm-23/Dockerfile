FROM ubuntu:22.04 as build

RUN apt update && apt install -y \
    build-essential fakeroot devscripts equivs \
    gcc make libssl-dev libmunge-dev tar wget \
    libfreeipmi-dev libreadline-dev \
    systemd \
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

RUN apt update && apt install -y /opt/*.deb
RUN useradd --system -U slurm

# Configure

COPY slurm.conf slurm.key slurm.cert /etc/slurm/

# sshd

RUN apt install -y openssh-server

# xenon user

RUN groupadd --system xenon && useradd --system --gid xenon --create-home xenon

RUN echo xenon:javagat | chpasswd

USER xenon
WORKDIR /home/xenon

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

# systemd 
# from https://github.com/gdraheim/docker-systemctl-replacement

RUN apt install -y python3.11 python3-pip less && \
    pip install docker-systemctl-replacement && \
    rm /usr/bin/systemctl && \
    ln -s /usr/local/bin/systemctl.py /usr/bin/systemctl

# entrypoint

ADD entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
