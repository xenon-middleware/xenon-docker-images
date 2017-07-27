FROM agaveapi/torque
MAINTAINER Stefan Verhoeven "s.verhoeven@esciencecenter.nl"

RUN trqauthd start && \ 
    ./torque.setup root localhost && \
    pbs_mom && pbs_sched && \
    qmgr -c "create queue debug queue_type=execution" && \
    qmgr -c "set queue debug enabled=true" && \
    qmgr -c "set queue debug started=true" && \
    qmgr -c "set server scheduling=True" && \
    qmgr -c 'set queue batch resources_default.walltime = 48:00:00' && \
    qmgr -c 'set queue batch resources_default.nodes = 1' && \
    qmgr -c 'set server default_queue = debug' && \
    qmgr -c 'set server scheduler_iteration = 2'

# Create a user 'xenon' with password 'javagat'
RUN /usr/sbin/useradd -p $(openssl passwd javagat) xenon

WORKDIR /home/xenon

# copy ssh config directory from Docker context to xenon's home directory
COPY .ssh .ssh

RUN chmod 700 .ssh && \
chmod 600 .ssh/id_rsa .ssh/id_dsa && \
chmod 644 .ssh/authorized_keys .ssh/id_rsa.pub .ssh/id_dsa.pub && \
chown -R xenon.xenon .ssh

# Xenon's filesystem integration tests expect certain directory structure, create it here:
RUN mkdir -p filesystem-test-fixture/links && \
echo "Hello World" > filesystem-test-fixture/links/file0 && \
touch filesystem-test-fixture/links/file1 && \
ln -s /home/xenon/filesystem-test-fixture/links/file0 /home/xenon/filesystem-test-fixture/links/link0 && \
ln -s /home/xenon/filesystem-test-fixture/links/file1 /home/xenon/filesystem-test-fixture/links/link1 && \
ln -s /home/xenon/filesystem-test-fixture/links/file2 /home/xenon/filesystem-test-fixture/links/link2 && \
ln -s /home/xenon/filesystem-test-fixture/links/link0 /home/xenon/filesystem-test-fixture/links/link3 && \
ln -s /home/xenon/filesystem-test-fixture/links/link2 /home/xenon/filesystem-test-fixture/links/link4 && \
ln -s /home/xenon/filesystem-test-fixture/links/link6 /home/xenon/filesystem-test-fixture/links/link5 && \
ln -s /home/xenon/filesystem-test-fixture/links/link5 /home/xenon/filesystem-test-fixture/links/link6 && \
chown -R xenon.xenon /home/xenon/filesystem-test-fixture

ADD docker_entrypoint.sh /docker_entrypoint.sh

# Expose sshd port
EXPOSE 22

# define the test that tells us if the docker container is healthy
# ping ssh and pbs node
HEALTHCHECK --interval=1s CMD ssh -o NoHostAuthenticationForLocalhost=yes -i /home/xenon/.ssh/id_rsa xenon@localhost /bin/true && pbsnodes -l free $(hostname) || exit 1
