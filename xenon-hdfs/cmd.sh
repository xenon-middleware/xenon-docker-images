hadoop namenode -format -force
hdfs namenode &
sleep 5s
hdfs datanode &
sleep 5s
sudo -E -u xenon hdfs dfsadmin -safemode wait
sudo -E -u xenon ./bin/hdfs dfs -mkdir /filesystem-test-fixture
sudo -E -u xenon ./bin/hdfs dfs -mkdir /filesystem-test-fixture/links
sudo -E -u xenon echo "Hello World" > file0
sudo -E -u xenon ./bin/hdfs dfs -put file0 /filesystem-test-fixture/links/
sudo -E -u xenon echo "" > file1
sudo -E -u xenon ./bin/hdfs dfs -put file1 /filesystem-test-fixture/links/
touch /opt/hadoop/up
echo DONE!!!!!!!!!!
wait
