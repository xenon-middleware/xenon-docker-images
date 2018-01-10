/usr/bin/supervisord -c /etc/supervisord.conf &
sleep 5s
hadoop namenode -format
hdfs namenode &
sleep 5s
hdfs datanode &
sleep 5s
sudo -u xenon kinit -k -t /home/xenon/xenon.keytab xenon@esciencecenter.nl

chmod a+x /loginxenon.sh
sudo -E -u xenon /loginxenon.sh
sudo -E -u xenon hdfs dfsadmin -safemode wait
sudo -E -u xenon ./bin/hdfs dfs -mkdir /filesystem-test-fixture
sudo -E -u xenon ./bin/hdfs dfs -mkdir /filesystem-test-fixture/links
sudo -E -u xenon echo "Hello World" > file0
sudo -E -u xenon ./bin/hdfs dfs -put file0 /filesystem-test-fixture/links/
sudo -E -u xenon echo "" > file1
sudo -E -u xenon ./bin/hdfs dfs -put file1 /filesystem-test-fixture/links/

echo DONE!!!!!!!!!!!
touch /opt/hadoop/up
wait
