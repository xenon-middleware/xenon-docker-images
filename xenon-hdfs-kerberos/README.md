Docker container with simple HDFS installation that uses Kerberos for authentication.

Kerberos is initialized with the user "xenon" and password "Javagat"

### Build with

```bash
cd xenon-hdfs-kerberos
docker build -t nlesc/xenon-hdfs-kerberos .
```

### Run with

```bash
docker run --detach --name=xenon-hdfs-kerberos --hostname xenon-hdfs-kerberos -p 8020:8020 -p 50010:50010 -p 50075:50075 nlesc/xenon-hdfs-kerberos

# You can now reach the web interface of the DataNode on http://localhost:50075
curl http://localhost:50075/jmx?qry=Hadoop:name=FSDatasetState,service=DataNode 

# Clean up the run
docker rm -f xenon-hdfs-kerberos
```
