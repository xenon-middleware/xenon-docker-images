Docker container with ftp server, to run the xenon ftp adaptor integration
tests against.

The container has one ftp user

- ``xenon``, with password ``javagat``, and read and write rights;

# Build with

```
cd xenon-ftp-small
docker build --tag nlesc/xenon-ftp-small .
```

# Run with

```
# needs '-p 3000-3100:3000-3100' because ftp protocol can switch ports
docker run --detach --name=xenon-ftp-small --hostname xenon-ftp --network host nlesc/xenon-ftp-small

# Login using lftp client (https://lftp.yar.ru/) by
lftp ftp://xenon:javagat@localhost

# or for anonymous access
lftp ftp://localhost

# Clean up the run
docker rm -f xenon-ftp-small

```
