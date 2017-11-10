Docker container with simple HDFS installation.

### Build with

```bash
cd xenon-hdfs
docker build -t nlesc/xenon-hdfs .
```

### Run with

```bash
docker run --detach --name=xenon-hdfs --hostname xenon-hdfs -p 8020:8020 -p 50010:50010 -p 50070:50070 -p 50075:50075 nlesc/xenon-hdfs

# You can now run HDFS commands inside the docker...
docker exec -i -t xenon-hdfs /opt/hadoop/bin/hdfs dfsadmin -report

# ...and reach the web interface of the NameNode on http://localhost:50070 
curl http://localhost:50070/jmx?qry=Hadoop:service=NameNode,name=NameNodeInfo

# ...and the DataNode on http://localhost:50075
curl http://localhost:50075/jmx?qry=Hadoop:name=FSDatasetState,service=DataNode 

# Clean up the run
docker rm -f xenon-hdfs
```
