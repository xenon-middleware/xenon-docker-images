FROM alpine:3.6
MAINTAINER Stefan Verhoeven "s.verhoeven@esciencecenter.nl"

# Create a test user
RUN /usr/sbin/adduser -s /bin/sh -D xenon && \
# set user xenon's password to javagat
echo xenon:javagat | chpasswd

WORKDIR /home/xenon

# add ssh config directory
COPY .ssh .ssh

RUN chmod 700 .ssh && \
chmod 600 .ssh/id_rsa .ssh/id_dsa && \
chmod 644 .ssh/authorized_keys .ssh/id_rsa.pub .ssh/id_dsa.pub && \
chown -R xenon.xenon .ssh

# use package manageer to install Bash
RUN apk add --no-cache bash

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
