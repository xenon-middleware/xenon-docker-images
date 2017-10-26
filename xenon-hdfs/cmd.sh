hdfs namenode & 
sleep 5s 
hdfs datanode &
sudo -u xenon hdfs dfsadmin -safemode wait 
touch /opt/hadoop/up 
echo DONE!!!!!!!!!!!
wait
