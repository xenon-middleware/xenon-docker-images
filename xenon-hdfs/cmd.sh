hdfs namenode & 
sleep 3s 
hdfs datanode &
sudo -u xenon hdfs dfsadmin -safemode wait 
sleep 3s
touch /opt/hadoop/up 
echo DONE!!!!!!!!!!!
wait
