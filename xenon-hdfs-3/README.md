Docker container with simple HDFS installation using Hadoop 3.

### Build with

```bash
cd xenon-hdfs3
docker build -t nlesc/xenon-hdfs-3 .
```

### Run with

```bash
docker run --detach --name=xenon-hdfs-3 --hostname xenon-hdfs-3 -p 9820:9820 -p 9866:9866 -p 9870:9870 -p 9864:9864 nlesc/xenon-hdfs-3

# You can now run HDFS commands inside the docker...
docker exec -i -t xenon-hdfs /opt/hadoop/bin/hdfs dfsadmin -report

# ...and reach the web interface of the NameNode on http://localhost:9870 
curl http://localhost:9870/jmx?qry=Hadoop:service=NameNode,name=NameNodeInfo

# ...and the DataNode on http://localhost:9864
curl http://localhost:9864/jmx?qry=Hadoop:name=FSDatasetState,service=DataNode 

# Clean up the run
docker rm -f xenon-hdfs
```
