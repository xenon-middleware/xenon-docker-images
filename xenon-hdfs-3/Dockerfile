FROM nlesc/xenon-phusion-base

# Inspired from mdouchement/hdfs (has MIT license)
#RUN apk --no-cache add curl procps sudo
RUN apt update && apt install -y openjdk-8-jre && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && mkdir /etc/service/namenode /etc/service/datanode

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/jre

WORKDIR /opt

# Install Hadoop
RUN curl -s http://apache.cs.uu.nl/hadoop/common/hadoop-3.1.1/hadoop-3.1.1.tar.gz -o hadoop.tar.gz && \
    tar -xzf hadoop.tar.gz && \
    rm hadoop.tar.gz && \
    rm -rf hadoop-3.1.1/share/doc/ && \
    mv hadoop-3.1.1 hadoop && \
    mkdir /opt/hadoop/logs && \
    echo done

WORKDIR /opt/hadoop

ENV PATH /opt/hadoop/bin:/opt/hadoop/sbin:$PATH

# Pseudo-Distributed Operation
COPY etc/hadoop/core-site.xml etc/hadoop/core-site.xml
COPY etc/hadoop/hdfs-site.xml etc/hadoop/hdfs-site.xml
COPY etc/service/namenode.run /etc/service/1namenode/run
COPY etc/service/datanode.run /etc/service/2datanode/run

COPY cmd.sh /cmd.sh

RUN /bin/chmod +x /cmd.sh /etc/service/namenode/run /etc/service/datanode/run

# hdfs://localhost:9820
EXPOSE 9820
EXPOSE 9866
EXPOSE 9867
EXPOSE 9870
EXPOSE 9864
EXPOSE 9868

HEALTHCHECK --interval=1s CMD hadoop fs -test -e / || exit 1
