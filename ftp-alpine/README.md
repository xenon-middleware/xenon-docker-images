Docker container with ftp server, to run the xenon ftp adaptor integration
tests against.

The container has one ftp user

- ``xenon``, with password ``javagat``, and read and write rights;
- anonymous user with readonly rights

**Available tags**

| tag | Dockerfile (on GitHub)|
|---|---|
|latest| [xenon-ftp/Dockerfile](https://github.com/NLeSC/xenon-docker-images/blob/master/xenon-ftp/Dockerfile)
|alpine| [xenon-ftp-alpine/Dockerfile](https://github.com/NLeSC/xenon-docker-images/blob/master/xenon-ftp-alpine/Dockerfile)

# Build with

```
cd xenon-ftp-alpine
docker build --tag xenonmiddleware/ftp:<tag> .
```

Replace `<tag>` with a tag from the table in the previous chapter.

# Run with

```
# needs '-p 3000-3100:3000-3100' because ftp protocol can switch ports
docker run --detach --name=xenon-ftp --hostname xenon-ftp --network host xenonmiddleware/ftp:<tag>

# Login using lftp client (https://lftp.yar.ru/) by
lftp ftp://xenon:javagat@localhost

# or for anonymous access
lftp ftp://localhost

# Clean up the run
docker rm -f xenon-ftp:<tag>
```
