FROM nlesc/xenon-phusion-base
LABEL maintainer="Stefan Verhoeven <s.verhoeven@esciencecenter.nl>"

RUN apt update && apt install -y openjdk-8-jre && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/jre

WORKDIR /opt

# Install Hadoop
RUN curl -s http://apache.cs.uu.nl/hadoop/common/hadoop-3.1.1/hadoop-3.1.1.tar.gz -o hadoop.tar.gz && \
    tar -xzf hadoop.tar.gz && \
    rm hadoop.tar.gz && \
    rm -rf hadoop-3.1.1/share/doc/ hadoop-3.1.1/share/yarn hadoop-3.1.1/share/mapreduce hadoop-3.1.1/share/tools && \
    mv hadoop-3.1.1 hadoop && \
    mkdir /opt/hadoop/logs && \
    echo done

WORKDIR /opt/hadoop

ENV PATH /opt/hadoop/bin:/opt/hadoop/sbin:$PATH

RUN mkdir /etc/service/1namenode /etc/service/2datanode

# Pseudo-Distributed Operation
COPY etc/hadoop/core-site.xml etc/hadoop/core-site.xml
COPY etc/hadoop/hdfs-site.xml etc/hadoop/hdfs-site.xml
COPY etc/service/namenode.run /etc/service/1namenode/run
COPY etc/service/datanode.run /etc/service/2datanode/run

COPY fill.sh /fill.sh

RUN sh /fill.sh && chmod +x /etc/service/1namenode/run /etc/service/2datanode/run

# Ports as described in https://issues.apache.org/jira/browse/HDFS-9427
EXPOSE 9820
EXPOSE 9870
EXPOSE 9871
EXPOSE 9866
EXPOSE 9867
EXPOSE 9864

HEALTHCHECK --interval=1s CMD (hdfs dfsadmin -safemode get | grep -q OFF) || exit 1
