hadoop namenode -format
hdfs namenode &
sleep 5s
hdfs datanode &
sleep 5s
sudo -u xenon hdfs dfsadmin -safemode wait
sudo -u xenon ./bin/hdfs dfs -mkdir /filesystem-test-fixture
sudo -u xenon ./bin/hdfs dfs -mkdir /filesystem-test-fixture/links
sudo -u xenon echo "Hello World" > file0
sudo -u xenon ./bin/hdfs dfs -put file0 /filesystem-test-fixture/links/
sudo -u xenon echo "" > file1
sudo -u xenon ./bin/hdfs dfs -put file1 /filesystem-test-fixture/links/
touch /opt/hadoop/up
echo DONE!!!!!!!!!!!
wait
