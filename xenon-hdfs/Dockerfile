FROM nlesc/xenon-ssh

# Inspired from mdouchement/hdfs (has MIT license)

RUN apk --update add openjdk7-jre && \
    apk add --update curl && \
    apk --no-cache add procps && \
		apk add sudo
WORKDIR /opt

# Disable sshd authentication
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config

# Install Hadoop
RUN curl -L http://apache.40b.nl/hadoop/common/hadoop-2.8.1/hadoop-2.8.1.tar.gz -s -o - | tar -xzf -
RUN mv hadoop-2.8.1 hadoop


WORKDIR /opt/hadoop
ENV PATH /opt/hadoop/bin:/opt/hadoop/sbin:$PATH

RUN sed --in-place='.ori' -e "s/\${JAVA_HOME}/\/usr\/lib\/jvm\/java-1.7-openjdk\/jre/" etc/hadoop/hadoop-env.sh

# Configure ssh client
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 0600 ~/.ssh/authorized_keys


ENV JAVA_HOME /usr/lib/jvm/java-1.7-openjdk/jre/


# Pseudo-Distributed Operation
COPY etc/hadoop/core-site.xml etc/hadoop/core-site.xml
COPY etc/hadoop/hdfs-site.xml etc/hadoop/hdfs-site.xml
RUN hdfs namenode -format

RUN \
	/usr/sbin/sshd && \
  start-dfs.sh && \
  hadoop-daemon.sh start portmap && \
  hadoop-daemon.sh start nfs3 && \
	su xenon && \
	sudo -u xenon ./bin/hdfs dfs -mkdir /filesystem-test-fixture && \
  sudo -u xenon ./bin/hdfs dfs -mkdir /filesystem-test-fixture/links && \
  sudo -u xenon echo "Hello World" > file0 && \
	sudo -u xenon ./bin/hdfs dfs -put file0 /filesystem-test-fixture/links/ && \
	sudo -u xenon echo "" > file1 && \
	sudo -u xenon ./bin/hdfs dfs -put file1 /filesystem-test-fixture/links/ && \
  hadoop-daemon.sh stop nfs3 && \
  hadoop-daemon.sh stop portmap && \
  stop-dfs.sh 




# SSH
EXPOSE 22
# hdfs://localhost:8020
EXPOSE 8020
# HDFS namenode
EXPOSE 50020
# HDFS Web browser
EXPOSE 50070
# HDFS datanodes
EXPOSE 50075
# HDFS secondary namenode
EXPOSE 50090

CMD /usr/sbin/sshd \
  && start-dfs.sh \
  && hadoop-daemon.sh start portmap \
  && hadoop-daemon.sh start nfs3 \
  && bash
