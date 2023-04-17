#
# docker build -t xenonmiddleware/dirac:latest --add-host dirac-tuto:172.17.0.2 --progress plain .
#
# docker run --privileged --hostname dirac-tuto xenonmiddleware/dirac:latest
# (to run apptainer containers requires the --privileged flag)
#
# For debugging:
# docker run --privileged -ti --rm --hostname dirac-tuto --entrypoint bash xenonmiddleware/dirac:latest
#
# Follows the instructions from:
# https://dirac.readthedocs.io/en/latest/AdministratorGuide/Tutorials/basicTutoSetup.html
# and
# https://github.com/DIRACGrid/DIRAC/blob/integration/docs/source/AdministratorGuide/Tutorials/basicTutoSetup.sh

FROM diracgrid/cc7-dirac

RUN yum install -y tzdata passwd patch

# Dont need apptainer as it is part of diracos conda environment
#RUN yum install -y apptainer tzdata passwd
# CMD ["apptainer", "run", "docker://sylabsio/lolcow:latest"]

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
    echo "ALTER USER 'root'@'localhost' IDENTIFIED BY 'password';FLUSH PRIVILEGES;" | mysql -B -u root

# 2023-04-17 14:55:52 UTC dirac-setup-site/MySQL [139876592334656] DEBUG: _query: SHOW STATUS
# 2023-04-17 14:55:52 UTC dirac-setup-site [139876592334656] DEBUG: SHOW STATUS : OK
# 2023-04-17 14:55:52 UTC dirac-setup-site/MySQL [139876592334656] DEBUG: _query: CREATE DATABASE `InstalledComponentsDB`
# 2023-04-17 14:55:52 UTC dirac-setup-site [139876592334656] DEBUG: CREATE DATABASES : OK
# 2023-04-17 14:55:52 UTC dirac-setup-site/MySQL [139876592334656] DEBUG: _query: GRANT SELECT,INSERT,LOCK TABLES,UPDATE,DELETE,CREATE,DROP,ALTER,REFERENCES,CREATE VIEW,SHOW VIEW,INDEX,TRIGGER,ALTER ROUTINE,CREATE ROUTINE ON `InstalledComponentsDB`.* TO 'Dirac'@'%'
# 2023-04-17 14:55:52 UTC dirac-setup-site/MySQL [139876592334656] ERROR: _query (GRANT SELECT,INSERT,LOCK TABLES,UPDATE,DELETE,CREATE,DROP,ALTER,REFERENCES,CREATE VIEW,SHOW VIEW,INDEX,TRIGGER,ALTER ROUTINE,CREATE ROUTINE ON `InstalledComponentsDB`.* TO 'Dirac'@'%'): Execution failed. 1133: Can't find any matching row in the user table
# 2023-04-17 14:55:52 UTC dirac-setup-site [139876592334656] ERROR: Error executing 'GRANT SELECT,INSERT,LOCK TABLES,UPDATE,DELETE,CREATE,DROP,ALTER,REFERENCES,CREATE VIEW,SHOW VIEW,INDEX,TRIGGER,ALTER ROUTINE,CREATE ROUTINE ON `InstalledComponentsDB`.* TO 'Dirac'@'%'' MySQL Error ( 1131 : Execution failed.: ( 1133: Can't find any matching row in the user table ))
# 2023-04-17 14:55:52 UTC dirac-setup-site [139876592334656] ERROR: Error executing 'GRANT SELECT,INSERT,LOCK TABLES,UPDATE,DELETE,CREATE,DROP,ALTER,REFERENCES,CREATE VIEW,SHOW VIEW,INDEX,TRIGGER,ALTER ROUTINE,CREATE ROUTINE ON `InstalledComponentsDB`.* TO 'Dirac'@'%''
# Possibly fixed by creating Dirac user

COPY runsvdir-start /opt/dirac/sbin/runsvdir-start

RUN chmod +x /opt/dirac/sbin/runsvdir-start && \
    chown dirac:dirac /opt/dirac/sbin/runsvdir-start

WORKDIR /home/dirac

COPY setupCA ./

RUN chmod +x setupCA && chown dirac:dirac setupCA && ln -s /opt/dirac/etc/grid-security /etc/grid-security

# USER dirac

RUN ./setupCA

WORKDIR /opt/dirac

COPY install.cfg install_site.sh.patch ./

# RUN sed -i "s/dirac-tuto/${HOSTNAME}/"g install.cfg && 

RUN curl -O https://raw.githubusercontent.com/DIRACGrid/management/master/install_site.sh && \
    chmod +x install_site.sh && \
    patch install_site.sh install_site.sh.patch && \
    chown dirac:dirac -R /opt/dirac

# For some reason `eval "$(${DIRACOS}/bin/micromamba shell hook activate -s bash)"` line in diracosrc 
# does not activate the conda environment in a runit Configuration_Server run script
# so we patch installer to brute activate the conda environment
# runsvstat /opt/dirac/startup/*

# Services are only available within same run command
# As installer needs mysql to be running we have to start mysql in the same run command
RUN nohup bash -c '/bin/entrypoint.sh &' && \
    ln -s /var/lib/mysql/mysql.sock /tmp/mysql.sock && \
    su dirac -c './install_site.sh install.cfg'

# 2023-04-17 14:39:58 UTC dirac-setup-site [140578409948992] ERROR: Cannot connect to the DB  MySQL Error ( 1131 : Could not connect: (2002, "Can't connect to local MySQL server through socket '/tmp/mysql.sock' (2)"))
# 2023-04-17 14:39:58 UTC dirac-setup-site [140578409948992] ERROR: Could not connect to MySQL server
# ERROR: Could not connect to MySQL server
# Fixed by symlinking mysql.sock

# TODO https://dirac.readthedocs.io/en/latest/AdministratorGuide/Tutorials/installWMS.html and its prerequisites

CMD ["/bin/entrypoint.sh"]
