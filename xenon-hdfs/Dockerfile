FROM mdouchement/hdfs 

MAINTAINER Atze van der Ploeg (a.vanderploeg@esciencecenter.nl)



WORKDIR /opt/hadoop/


RUN \
	service ssh start && \
  start-dfs.sh && \
  hadoop-daemon.sh start portmap && \
  hadoop-daemon.sh start nfs3 && \
	./bin/hdfs dfs -mkdir /filesystem-test-fixture && \
  ./bin/hdfs dfs -mkdir /filesystem-test-fixture/links && \
  echo "Hello World" > file0 && \
	./bin/hdfs dfs -put file0 /filesystem-test-fixture/links/ && \
	echo "" > file1 && \
	./bin/hdfs dfs -put file1 /filesystem-test-fixture/links/ && \
  service ssh stop && \ 
  hadoop-daemon.sh stop nfs3 && \
  hadoop-daemon.sh stop portmap


