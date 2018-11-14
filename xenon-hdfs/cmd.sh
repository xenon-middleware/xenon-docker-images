hdfs namenode -format -force
hdfs namenode &
sleep 5s
hdfs datanode &
sleep 5s
hdfs dfsadmin -safemode wait
hdfs dfs -mkdir /filesystem-test-fixture
hdfs dfs -mkdir /filesystem-test-fixture/links
echo "Hello World" > file0
hdfs dfs -put file0 /filesystem-test-fixture/links/
echo "" > file1
hdfs dfs -put file1 /filesystem-test-fixture/links/
hdfs dfs -chown -R xenon:xenon /filesystem-test-fixture
wait
