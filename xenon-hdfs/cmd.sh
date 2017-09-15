/usr/bin/supervisord -c /etc/supervisord.conf &
hdfs namenode & 
sleep 5s 
hdfs datanode &
hdfs dfsadmin -safemode wait 
touch /opt/hadoop/up 
wait
