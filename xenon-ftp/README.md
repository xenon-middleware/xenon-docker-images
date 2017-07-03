Docker container with ftp server, to run the xenon ftp adaptor integration
tests against.

The container has two ftp users

- ``xenon``, with password ``javagat``, and read and write rights;
- anonymous user with readonly rights

# Build with

```
cd xenon-ftp
docker build --tag nlesc/xenon-ftp .
```

# Run with

```
# needs '--network host' because ftp protocol can switch ports
docker run --detach --name=xenon-ftp --hostname xenon-ftp --network host nlesc/xenon-ftp

# Login using lftp client (https://lftp.yar.ru/) by
lftp ftp://xenon:javagat@localhost

# or for anonymous access
lftp ftp://localhost

# Clean up the run
docker rm -f xenon-ftp

```
