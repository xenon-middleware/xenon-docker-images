FROM xenon-fixture

# become root user
USER root

# install SSH client
RUN apt-get update && apt-get install -y openssh-server

# generate the different types of keys that ssh needs
RUN ssh-keygen -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key && \
ssh-keygen -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key && \
ssh-keygen -N "" -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key && \
ssh-keygen -N "" -t ed25519 -f /etc/ssh/ssh_host_ed25519_key

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

# add the supervisor configuration for starting ssh
ADD supervisor/sshd.conf /etc/supervisor/sshd.conf

