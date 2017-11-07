/usr/bin/supervisord -c /etc/supervisord.conf &
sleep 3s
hdfs namenode & 
sleep 3s 
hdfs datanode &
sudo -u xenon kinit -k -t /home/xenon/xenon.keytab xenon@esciencecenter.nl
sudo -u xenon hdfs dfsadmin -safemode wait 
sleep 3s
sudo -u xenon hdfs dfsadmin -safemode wait 
echo DONE!!!!!!!!!!!
touch /opt/hadoop/up 
wait
