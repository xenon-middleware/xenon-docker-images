/usr/bin/supervisord -c /etc/supervisord.conf &
sleep 5s
hadoop namenode -format
hdfs namenode &
sleep 5s
hdfs datanode &
sleep 5s
sudo -u xenon kinit -k -t /home/xenon/xenon.keytab xenon@esciencecenter.nl

chmod a+x /loginxenon.sh
sudo -u xenon /loginxenon.sh
sudo -u xenon hdfs dfsadmin -safemode wait
sudo -u xenon ./bin/hdfs dfs -mkdir /filesystem-test-fixture
sudo -u xenon ./bin/hdfs dfs -mkdir /filesystem-test-fixture/links
sudo -u xenon echo "Hello World" > file0
sudo -u xenon ./bin/hdfs dfs -put file0 /filesystem-test-fixture/links/
sudo -u xenon echo "" > file1
sudo -u xenon ./bin/hdfs dfs -put file1 /filesystem-test-fixture/links/

echo DONE!!!!!!!!!!!
touch /opt/hadoop/up
wait
