Docker container with ftp server, to run the xenon ftp adaptor integration
tests against.

The container has two ftp users

- ``xenon``, with password ``javagat``, and read and write rights;
- anonymous user with readonly rights

# Build with

```
docker build --tag nlesc/xenon-ftp .
```

# Run with

```
docker run --detach --name=xenon-ftp --hostname xenon-ftp nlesc/xenon-ftp

# Get containers ip with
XENON_FTP_LOCATION=$(docker inspect -f "{{ .NetworkSettings.IPAddress }}" xenon-ftp)

# Login using lftp client (https://lftp.yar.ru/) by
lftp ftp://xenon:javagat@$XENON_FTP_LOCATION

# or for anonymous access
lftp ftp://$XENON_FTP_LOCATION

# Clean up the run
docker rm -f xenon-ftp

```
