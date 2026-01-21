FROM ubuntu:22.04

LABEL org.opencontainers.image.source=https://github.com/xenon-middleware/xenon-docker-images
LABEL org.opencontainers.image.documentation=https://github.com/xenon-middleware/xenon-docker-images/blob/dirac/diracclient/README.md
LABEL org.opencontainers.image.licenses=Apache-2.0

RUN apt update && apt install -y curl

RUN useradd diracuser -m -s /bin/bash && \
    echo diracuser:password | /usr/sbin/chpasswd

USER diracuser
WORKDIR /home/diracuser

# TODO reuse /cvmfs/dirac.egi.eu/dirac/v8r0p49/Linux-x86_64/
# from dirac image
RUN curl -LO https://github.com/DIRACGrid/DIRACOS2/releases/latest/download/DIRACOS-Linux-$(uname -m).sh && \
    bash DIRACOS-Linux-$(uname -m).sh && \
    rm DIRACOS-Linux-$(uname -m).sh

RUN echo '. /home/diracuser/diracos/diracosrc' >> /home/diracuser/.profile
SHELL ["/bin/bash", "-l", "-c"]
# TODO silence `#0 0.490 realpath: '': No such file or directory` warnings from diracosrc script

RUN pip install DIRAC==8.0.49

# Copy host certs, so server is trusted by dirac clients
COPY --chown=diracuser:diracuser --from=ghcr.io/xenon-middleware/dirac:8.0.49 /opt/dirac/etc/grid-security/certificates /etc/grid-security/certificates

# Copy diracuser certs from dirac image to here
COPY --chown=diracuser:diracuser --from=ghcr.io/xenon-middleware/dirac:8.0.49 /home/diracuser/.globus /home/diracuser/.globus
COPY --chown=diracuser:diracuser --from=ghcr.io/xenon-middleware/dirac:8.0.49 /home/diracuser/dirac.cfg /home/diracuser/diracos/etc/dirac.cfg

VOLUME /src
WORKDIR /src

ENTRYPOINT ["/bin/bash", "-l", "-c"]
