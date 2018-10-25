hdfs dfsadmin -safemode wait
hdfs dfs -mkdir /filesystem-test-fixture
hdfs dfs -mkdir /filesystem-test-fixture/links
echo "Hello World" | hdfs dfs -put - /filesystem-test-fixture/links/file0
echo "" | hdfs dfs -put - /filesystem-test-fixture/links/file1
hdfs dfs -chown -R xenon:xenon /filesystem-test-fixture
