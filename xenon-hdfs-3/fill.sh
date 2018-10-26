#!/bin/sh

hadoop namenode -format -force

hdfs namenode &
hdfs datanode &

hdfs dfsadmin -safemode wait
hdfs dfs -mkdir /filesystem-test-fixture
hdfs dfs -mkdir /filesystem-test-fixture/links
echo "Hello World" | hdfs dfs -put - /filesystem-test-fixture/links/file0
echo "" | hdfs dfs -put - /filesystem-test-fixture/links/file1
hdfs dfs -chown -R xenon:xenon /filesystem-test-fixture

hdfs --daemon stop datanode
hdfs --daemon stop namenode
