FROM ubuntu:22.04

ARG diracos_version=2.31
ARG dirac_version=8.0.18

RUN apt update && apt install -y curl

RUN useradd diracuser -m -s /bin/bash && \
    echo diracuser:password | /usr/sbin/chpasswd

USER diracuser
WORKDIR /home/diracuser

RUN curl -LO https://github.com/DIRACGrid/DIRACOS2/releases/download/${diracos_version}/DIRACOS-2.31-Linux-x86_64.sh && \
    bash DIRACOS-Linux-$(uname -m).sh && \
    rm DIRACOS-Linux-$(uname -m).sh

RUN echo '. /home/diracuser/diracos/diracosrc' >> /home/diracuser/.profile
SHELL ["/bin/bash", "-l", "-c"]
# TODO silence `#0 0.390 realpath: '': No such file or directory` warnings from diracosrc script

RUN pip install DIRAC==${dirac_version}

# Copy host certs, so server is trusted by dirac clients
COPY --chown=diracuser:diracuser --from=ghcr.io/xenon-middleware/dirac:${dirac_version} /opt/dirac/etc/grid-security/certificates /etc/grid-security/certificates

# Copy diracuser certs from dirac image to here
COPY --chown=diracuser:diracuser --from=ghcr.io/xenon-middleware/dirac:${dirac_version} /home/diracuser/.globus /home/diracuser/.globus
COPY --chown=diracuser:diracuser --from=ghcr.io/xenon-middleware/dirac:${dirac_version} /home/diracuser/dirac.cfg /home/diracuser/diracos/etc/dirac.cfg 

VOLUME /src
WORKDIR /src

# COPY pyproject.toml .

# RUN pip install -e .[dev]
