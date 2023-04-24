FROM diracgrid/cc7-dirac

LABEL org.opencontainers.image.source=https://github.com/xenon-middleware/xenon-docker-images
LABEL org.opencontainers.image.documentation=https://github.com/xenon-middleware/xenon-docker-images/blob/dirac/dirac/README.md
LABEL org.opencontainers.image.licenses=Apache-2.0

ARG dirac_version=8.0.18
ARG dirac_pilot_version=v8r0p18

# Use BUILDKIT_SANDBOX_HOSTNAME to force hostname
# see https://docs.docker.com/engine/reference/builder/#buildkit-built-in-build-args

RUN yum install -y tzdata passwd patch openssh-server

COPY MariaDB.repo /etc/yum.repos.d/MariaDB.repo
COPY entrypoint.sh /bin/entrypoint.sh

RUN yum install -y MariaDB-server MariaDB-client 

RUN adduser -s /bin/bash -d /home/dirac dirac || echo "User dirac already exists." && \
    echo password | /usr/bin/passwd --stdin dirac && \
    chmod +x /bin/entrypoint.sh && \
    mkdir -p /opt/dirac/sbin /opt/dirac/startup && \
    chown -R dirac:dirac /opt/dirac/

# Calls for a random number to break the cahing of the git clone
# (https://stackoverflow.com/questions/35134713/disable-cache-for-specific-run-commands/58801213#58801213)
# ADD "https://www.random.org/cgi-bin/randbyte?nbytes=10&format=h" skipcache
RUN nohup bash -c 'mariadbd --default-time-zone=+00:00 --user=mysql &' && \
    sleep 3 && ps -ef && \
    echo "CREATE USER 'Dirac'@'%' IDENTIFIED BY 'Dirac';FLUSH PRIVILEGES;" | mysql -B -u root && \
    echo "CREATE USER 'Dirac'@'localhost' IDENTIFIED BY 'Dirac';FLUSH PRIVILEGES;" | mysql -B -u root && \
    echo "ALTER USER 'root'@'localhost' IDENTIFIED BY 'password';FLUSH PRIVILEGES;" | mysql -B -u root

# 2023-04-17 14:55:52 UTC dirac-setup-site/MySQL [139876592334656] DEBUG: _query: SHOW STATUS
# 2023-04-17 14:55:52 UTC dirac-setup-site [139876592334656] DEBUG: SHOW STATUS : OK
# 2023-04-17 14:55:52 UTC dirac-setup-site/MySQL [139876592334656] DEBUG: _query: CREATE DATABASE `InstalledComponentsDB`
# 2023-04-17 14:55:52 UTC dirac-setup-site [139876592334656] DEBUG: CREATE DATABASES : OK
# 2023-04-17 14:55:52 UTC dirac-setup-site/MySQL [139876592334656] DEBUG: _query: GRANT SELECT,INSERT,LOCK TABLES,UPDATE,DELETE,CREATE,DROP,ALTER,REFERENCES,CREATE VIEW,SHOW VIEW,INDEX,TRIGGER,ALTER ROUTINE,CREATE ROUTINE ON `InstalledComponentsDB`.* TO 'Dirac'@'%'
# 2023-04-17 14:55:52 UTC dirac-setup-site/MySQL [139876592334656] ERROR: _query (GRANT SELECT,INSERT,LOCK TABLES,UPDATE,DELETE,CREATE,DROP,ALTER,REFERENCES,CREATE VIEW,SHOW VIEW,INDEX,TRIGGER,ALTER ROUTINE,CREATE ROUTINE ON `InstalledComponentsDB`.* TO 'Dirac'@'%'): Execution failed. 1133: Can't find any matching row in the user table
# 2023-04-17 14:55:52 UTC dirac-setup-site [139876592334656] ERROR: Error executing 'GRANT SELECT,INSERT,LOCK TABLES,UPDATE,DELETE,CREATE,DROP,ALTER,REFERENCES,CREATE VIEW,SHOW VIEW,INDEX,TRIGGER,ALTER ROUTINE,CREATE ROUTINE ON `InstalledComponentsDB`.* TO 'Dirac'@'%'' MySQL Error ( 1131 : Execution failed.: ( 1133: Can't find any matching row in the user table ))
# 2023-04-17 14:55:52 UTC dirac-setup-site [139876592334656] ERROR: Error executing 'GRANT SELECT,INSERT,LOCK TABLES,UPDATE,DELETE,CREATE,DROP,ALTER,REFERENCES,CREATE VIEW,SHOW VIEW,INDEX,TRIGGER,ALTER ROUTINE,CREATE ROUTINE ON `InstalledComponentsDB`.* TO 'Dirac'@'%''
# Fixed by creating Dirac user in above RUN command

COPY runsvdir-start /opt/dirac/sbin/runsvdir-start

RUN chmod +x /opt/dirac/sbin/runsvdir-start && \
    chown dirac:dirac /opt/dirac/sbin/runsvdir-start

WORKDIR /home/dirac

COPY setupCA ./

RUN chmod +x setupCA && chown dirac:dirac setupCA && ln -s /opt/dirac/etc/grid-security /etc/grid-security

RUN ./setupCA

RUN ssh-keygen -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key && \
    ssh-keygen -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key && \
    ssh-keygen -N "" -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key && \
    ssh-keygen -N "" -t ed25519 -f /etc/ssh/ssh_host_ed25519_key && \
    echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config && \
    echo "HashKnownHosts no" >> /etc/ssh/ssh_config && \
    rm -f /run/nologin && \
    adduser -s /bin/bash -d /home/diracpilot diracpilot && \
    echo password | /usr/bin/passwd --stdin diracpilot

WORKDIR /opt/dirac

COPY install.cfg install_site.sh.patch post_install.sh ./


RUN curl -O https://raw.githubusercontent.com/DIRACGrid/management/master/install_site.sh && \
    chmod +x install_site.sh post_install.sh && \
    patch install_site.sh install_site.sh.patch && \
    chown dirac:dirac -R /opt/dirac

# For some reason `eval "$(${DIRACOS}/bin/micromamba shell hook activate -s bash)"` line in diracosrc 
# does not activate the conda environment in a runit Configuration_Server run script
# so we patch installer to brute activate the conda environment
# runsvstat /opt/dirac/startup/*

# Services are only available within same run command
# As installer needs mysql to be running we have to start mysql in the same run command.
# In tutorial the setup is configured as diracuser user, but here we use dirac user, so not to have diracos installed twice.
RUN nohup bash -c '/bin/entrypoint.sh &' && \
    ln -s /var/lib/mysql/mysql.sock /tmp/mysql.sock && \
    su dirac -c './install_site.sh -v ${dirac_version} install.cfg && ./post_install.sh ${dirac_pilot_version}'

# 2023-04-17 14:39:58 UTC dirac-setup-site [140578409948992] ERROR: Cannot connect to the DB  MySQL Error ( 1131 : Could not connect: (2002, "Can't connect to local MySQL server through socket '/tmp/mysql.sock' (2)"))
# 2023-04-17 14:39:58 UTC dirac-setup-site [140578409948992] ERROR: Could not connect to MySQL server
# ERROR: Could not connect to MySQL server
# Fixed by symlinking mysql.sock

# Generate cert that can be used in the browser
RUN openssl pkcs12 -export -out /opt/dirac/user/certificate.p12 -inkey /opt/dirac/user/client.key -in /opt/dirac/user/client.pem -passout pass:

# https://dirac.readthedocs.io/en/latest/AdministratorGuide/Tutorials/basicTutoSetup.html#client-installation

RUN adduser -s /bin/bash -d /home/diracuser diracuser || echo "User diracuser already exists." && \
    echo password | /usr/bin/passwd --stdin diracuser && \
    mkdir -p ~diracuser/.globus/ && \
    cp /opt/dirac/user/client.pem ~diracuser/.globus/usercert.pem && \
    cp /opt/dirac/user/client.key ~diracuser/.globus/userkey.pem && \
    openssl pkcs12 -export -out ~diracuser/.globus/certificate.p12 -inkey ~diracuser/.globus/userkey.pem -in ~diracuser/.globus/usercert.pem -passout pass: && \
    chown -R diracuser:diracuser ~diracuser/.globus/

# Fake CernVM File System, can be used for staging software 
RUN mkdir -p /cvmfs/my.repo.name && chmod 777 -R /cvmfs

COPY --chown=diracuser:diracuser dirac.client.cfg /home/diracuser/dirac.cfg

CMD ["/bin/entrypoint.sh"]

