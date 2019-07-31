Docker container with simple HDFS installation that uses Kerberos for authentication.

Kerberos is initialized with the user "xenon" and password "Javagat"

### Build with

```bash
cd xenon-hdfs-kerberos
docker build -t xenonmiddleware/hdfs-kerberos .
```

### Run with

```bash
docker run --detach --name=xenon-hdfs-kerberos --hostname xenon-hdfs-kerberos -p 8020:8020 -p 50010:50010 -p50470:50470 -p 50475:50475 xenonmiddleware/hdfs-kerberos

# You can now run HDFS commands inside the docker after login into kerberos...
docker exec -i -t xenon-hdfs-kerberos /bin/bash /loginxenon.sh
docker exec -i -t xenon-hdfs-kerberos /opt/hadoop/bin/hdfs dfsadmin -report

# ...and reach the web interface of the NameNode on http://localhost:50470 
curl -k https://localhost:50470/jmx?qry=Hadoop:service=NameNode,name=NameNodeInfo

# You can now reach the web interface of the DataNode on http://localhost:50475
curl -k https://localhost:50475/jmx?qry=Hadoop:name=FSDatasetState,service=DataNode

# Clean up the run
docker rm -f xenon-hdfs-kerberos
```
