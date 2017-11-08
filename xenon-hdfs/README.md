Docker container with simple HDFS installation.

### Build with

```bash
cd xenon-hdfs
docker build -t nlesc/xenon-hdfs .
```

### Run with

```bash
docker run --detach --name=xenon-hdfs --hostname xenon-hdfs -p 8020:8020 -p 50010:50010 -p 50075:50075 nlesc/xenon-hdfs

# Clean up the run
docker rm -f xenon-hdfs
```
