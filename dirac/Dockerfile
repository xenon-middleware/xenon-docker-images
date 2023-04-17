#
# docker build -t xenonmiddleware/dirac:latest  --progress plain .
#
# docker run --privileged xenonmiddleware/dirac:latest
# (to run apptainer containers requires the --privileged flag)
#
# For debugging:
# docker run --privileged -ti --entrypoint bash xenonmiddleware/dirac:latest
#
# Follows the instructions from:
# https://dirac.readthedocs.io/en/latest/AdministratorGuide/Tutorials/basicTutoSetup.html
# and
# https://github.com/DIRACGrid/DIRAC/blob/integration/docs/source/AdministratorGuide/Tutorials/basicTutoSetup.sh

FROM diracgrid/cc7-dirac

RUN yum install -y apptainer tzdata passwd

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
    echo "ALTER USER 'root'@'localhost' IDENTIFIED BY 'password';FLUSH PRIVILEGES;" | mysql -B -u root

COPY runsvdir-start /opt/dirac/sbin/runsvdir-start

RUN chmod +x /opt/dirac/sbin/runsvdir-start && \
    chown dirac:dirac /opt/dirac/sbin/runsvdir-start

WORKDIR /home/dirac

COPY setupCA ./

RUN chmod +x setupCA && chown dirac:dirac setupCA 

# USER dirac

RUN ./setupCA

WORKDIR /home/dirac/DiracInstallation

COPY install.cfg ./

RUN sed -i "s/dirac-tuto/${HOSTNAME}/"g install.cfg && chown dirac:dirac /home/dirac/DiracInstallation

RUN curl -O https://raw.githubusercontent.com/DIRACGrid/management/master/install_site.sh && \
    chmod +x install_site.sh

RUN nohup bash -c '/bin/entrypoint.sh &' && \
    su dirac -c './install_site.sh install.cfg'

CMD ["/bin/entrypoint.sh"]
