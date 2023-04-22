FROM ubuntu:22.04

RUN apt update && apt install -y curl

RUN useradd diracuser -m -s /bin/bash && \
    echo diracuser:password | /usr/sbin/chpasswd

USER diracuser
WORKDIR /home/diracuser

RUN curl -LO https://github.com/DIRACGrid/DIRACOS2/releases/latest/download/DIRACOS-Linux-$(uname -m).sh && \
    bash DIRACOS-Linux-$(uname -m).sh && \
    rm DIRACOS-Linux-$(uname -m).sh

RUN echo '. /home/diracuser/diracos/diracosrc' >> /home/diracuser/.profile
SHELL ["/bin/bash", "-l", "-c"]
# TODO silence `#0 0.390 realpath: '': No such file or directory` warnings from diracosrc script

RUN pip install DIRAC pytest

COPY --chown=diracuser:diracuser --from=ghcr.io/xenon-middleware/dirac:latest /home/diracuser/dirac.cfg /home/diracuser/diracos/etc/dirac.cfg 
COPY --chown=diracuser:diracuser --from=ghcr.io/xenon-middleware/dirac:latest /opt/dirac/etc/grid-security/certificates /etc/grid-security/certificates

# copy /home/diracuser from dirac image to here
COPY --chown=diracuser:diracuser --from=ghcr.io/xenon-middleware/dirac:latest /home/diracuser/.globus /home/diracuser/.globus

VOLUME /src
WORKDIR /src
