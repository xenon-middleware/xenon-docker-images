Docker container with [minio](https://minio.io/) S3 compatible server, to run the S3 adaptor integration tests against.

S3 server has accessKey `xenon` with secretKey `javagat01` (8 chars minimum, hence javagat01 instead of javagat)

The `filesystem-test-fixture` bucket has been populated with the test fixtures for the xenon filesystem adaptor integration tests.

# Build with:

```bash
cd s3
docker build -t xenonmiddleware/s3 .
```

# Run with:

```bash
docker run --detach --name=xenon-s3 --hostname xenon-s3 --publish 9000:9000 xenonmiddleware/s3
```

Test by using a browser to open http://127.0.0.1:9000

Clean up the run

```bash
docker rm -f xenon-s3
```
