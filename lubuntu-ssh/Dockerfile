FROM lubuntu-fixture

# become root user
USER root

# When this image is used as ssh client then ignore the known hosts
RUN echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config

# Don't hash the entries in /home/xenon/.ssh/known_hosts
RUN echo "HashKnownHosts no" >> /etc/ssh/ssh_config

# Expose the OpenSSH server on port 22
EXPOSE 22

# change into user xenon's home directory
WORKDIR /home/xenon/

# Add the ssh configuration from the Docker context to inside the Docker container
ADD .ssh .ssh

# SSH has strict requirements on the permissions of its configuration files, set them here
RUN chmod 700 .ssh && \
chmod 600 .ssh/id_rsa .ssh/id_dsa && \
chmod 644 .ssh/authorized_keys .ssh/id_rsa.pub .ssh/id_dsa.pub && \
chown -R xenon:xenon .ssh

