# Image which will run the Xenon isolated tests
# Will startup Docker containers to test against.
#
# Build with:
#
# docker build -t nlesc/xenon-test .
#
# At Xenon repo root dir run with:
#
# docker run \
#   -e MYUID=$UID \
#   --network host \
#   --name=xenon-client \
#   -ti --rm --privileged \
#   -v $HOME/.gradle:/home/xenon/.gradle \
#   -v $PWD:/code \
#   -v /var/run/docker.sock:/var/run/docker.sock \
#   nlesc/xenon-test
#
FROM nlesc/xenon-phusion-base
MAINTAINER Stefan Verhoeven "s.verhoeven@esciencecenter.nl"

# Instal Oracle jdk8 + docker
RUN apt-get update && apt-get install -y python-software-properties && \
add-apt-repository ppa:webupd8team/java -y && \
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable" && \
apt-get update && \
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
apt-get install -y docker-ce oracle-java8-installer oracle-java8-set-default expect && \
apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
# Install docker compose
curl -L https://github.com/docker/compose/releases/download/1.14.0/docker-compose-`uname -s`-`uname -m` > /usr/bin/docker-compose && \
chmod +x /usr/bin/docker-compose && \
mkdir /code && mkdir -p /etc/my_init.d && \
# Disable sshd, not needed
touch /etc/service/sshd/down && \
# Allow xenon user to access docker socket
usermod -aG docker xenon

# ssh keys are already installed in base image, config is needed by Xenon
RUN setuser xenon touch /home/xenon/.ssh/config

# Tests will be run by xenon user which has uid taken from MYUID environment var
ENV MYUID 1000
ADD entrypoint.sh /bin/entrypoint.sh
ADD ssh-fillpass-xenon /bin/ssh-fillpass-xenon

VOLUME ["/code"]
WORKDIR /code

ENTRYPOINT ["/bin/entrypoint.sh"]

# TODO after https://github.com/NLeSC/Xenon/issues/460 is implemented then use isolatedTest cmd
# CMD ["./gradlew", "--no-deamon", "isolatedTest"]
CMD ["./gradlew", "-Pxenon.test.properties=src/integrationTest/docker/xenon.test.properties.docker", "--project-cache-dir", "/home/xenon/gradle-cache", "integrationTest"]
