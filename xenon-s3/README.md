Docker container with [minio](https://minio.io/) S3 compatible server, to run the S3 adaptor integration tests against.

S3 server has accessKey `xenon` with secretKey `javagat01` (8 chars minimum, hence javagat01 instead of javagat)

# Build with:

```bash
cd xenon-s3
docker build -t nlesc/xenon-s3 .
```

# Run with:

```bash
docker run --detach --name=xenon-s3 --hostname xenon-s3 --publish 9000:9000 nlesc/xenon-s3
```

Test by using a browser to open http://127.0.0.1:9000

Clean up the run

```bash
docker rm -f xenon-s3
```
