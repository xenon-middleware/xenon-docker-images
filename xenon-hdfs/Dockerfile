FROM nlesc/xenon-phusion-base
LABEL maintainer="Stefan Verhoeven <s.verhoeven@esciencecenter.nl>"

RUN apt update && apt install -y openjdk-8-jre && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/jre

WORKDIR /opt

# Install Hadoop
RUN curl http://apache.cs.uu.nl/hadoop/common/hadoop-2.8.5/hadoop-2.8.5.tar.gz -o hadoop.tar.gz && \
    tar -xzvf hadoop.tar.gz && \
    rm hadoop.tar.gz && \
    rm -rf hadoop-2.8.5/share/doc/ && \
    mv hadoop-2.8.5 hadoop && \
    mkdir /opt/hadoop/logs && \
    echo done

WORKDIR /opt/hadoop

ENV PATH /opt/hadoop/bin:/opt/hadoop/sbin:$PATH

# Pseudo-Distributed Operation
COPY etc/hadoop/core-site.xml etc/hadoop/core-site.xml
COPY etc/hadoop/hdfs-site.xml etc/hadoop/hdfs-site.xml

COPY cmd.sh /cmd.sh

RUN /bin/chmod +x /cmd.sh

# hdfs://localhost:8020
EXPOSE 8020
EXPOSE 50010
EXPOSE 50020
EXPOSE 50070
EXPOSE 50075
EXPOSE 50090

CMD /cmd.sh

HEALTHCHECK --start-period=20s --interval=1s CMD hdfs dfs -test -e /filesystem-test-fixture/links/file0 || exit 1
