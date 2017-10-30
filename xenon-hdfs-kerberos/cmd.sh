/usr/bin/supervisord -c /etc/supervisord.conf &
sleep 5s
hdfs namenode & 
sleep 5s 
hdfs datanode &
sudo -u xenon kinit -k -t /home/xenon/xenon.keytab xenon@esciencecenter.nl
sudo -u xenon hdfs dfsadmin -safemode wait 
sleep 5s
sudo -u xenon hdfs dfsadmin -safemode wait 
echo DONE!!!!!!!!!!!
touch /opt/hadoop/up 
wait
