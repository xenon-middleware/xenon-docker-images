FROM nlesc/xenon-alpine-base

# Inspired from mdouchement/hdfs (has MIT license)

RUN apk --update add openjdk7-jre && \
    apk add --update curl && \
    apk --no-cache add procps && \
		apk add sudo
WORKDIR /opt


# Install Hadoop
RUN curl -L http://apache.40b.nl/hadoop/common/hadoop-2.8.1/hadoop-2.8.1.tar.gz -s -o - | tar -xzf -
RUN mv hadoop-2.8.1 hadoop


WORKDIR /opt/hadoop
ENV PATH /opt/hadoop/bin:/opt/hadoop/sbin:$PATH

RUN sed --in-place='.ori' -e "s/\${JAVA_HOME}/\/usr\/lib\/jvm\/java-1.7-openjdk\/jre/" etc/hadoop/hadoop-env.sh


ENV JAVA_HOME /usr/lib/jvm/java-1.7-openjdk/jre/


# Pseudo-Distributed Operation
COPY etc/hadoop/core-site.xml etc/hadoop/core-site.xml
COPY etc/hadoop/hdfs-site.xml etc/hadoop/hdfs-site.xml
COPY cmd.sh /cmd.sh


RUN \
  hadoop namenode -format && \
	(hdfs namenode &) && sleep 5s &&  (hdfs datanode &) && hdfs dfsadmin -safemode wait && \
	sudo -u xenon ./bin/hdfs dfs -mkdir /filesystem-test-fixture && \
  sudo -u xenon ./bin/hdfs dfs -mkdir /filesystem-test-fixture/links && \
  sudo -u xenon echo "Hello World" > file0 && \
	sudo -u xenon ./bin/hdfs dfs -put file0 /filesystem-test-fixture/links/ && \
	sudo -u xenon echo "" > file1 && \
	sudo -u xenon ./bin/hdfs dfs -put file1 /filesystem-test-fixture/links/ && \
	chmod a+x /cmd.sh




# hdfs://localhost:8020
EXPOSE 8020
EXPOSE 50010
EXPOSE 50020
EXPOSE 50070
EXPOSE 50075
EXPOSE 50090
# HDFS Web browser
EXPOSE 50070

CMD /cmd.sh

HEALTHCHECK --interval=1s CMD test -f /opt/hadoop/up || exit 1
