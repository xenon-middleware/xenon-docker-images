FROM nlesc/xenon-phusion-base
MAINTAINER Stefan Verhoeven "s.verhoeven@esciencecenter.nl"

# Install Java 10 or 11, docker compose and kerberos.  
RUN apt-get update && \
apt-get install -y openjdk-11-jdk docker-compose expect krb5-user krb5-config && \
apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
mkdir /code && mkdir -p /etc/my_init.d && \
# Disable sshd, not needed
touch /etc/service/sshd/down && \
usermod -aG docker xenon

# copy the kerberos config 
COPY krb5.conf /etc/krb5.conf

# ssh keys are already installed in base image, config is needed by Xenon
RUN setuser xenon touch /home/xenon/.ssh/config

# Tests will be run by xenon user which has uid taken from MYUID environment var
ENV MYUID 1000
ADD entrypoint.sh /bin/entrypoint.sh
ADD ssh-fillpass-xenon /bin/ssh-fillpass-xenon

VOLUME ["/code"]
WORKDIR /code

ENTRYPOINT ["/bin/entrypoint.sh"]

CMD ["./gradlew", "--no-daemon", "fixedClientEnvironmentTest"]
