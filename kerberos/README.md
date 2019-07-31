Docker container with kerberos server, used as a basis for other containers that need 
kerberos authentication (such as xenon-hdfs-kerberos).

In this container a user "xenon" is configured with password "javagat".

### Build with

```bash
cd xenon-kerberos
docker build -t xenonmiddleware/kerberos .
```

### Run with

```bash
docker run --detach --name=xenon-kerberos --hostname xenon-kerberos --publish 10022:22 xenonmiddleware/kerberos

# Access the container
docker exec -i -t xenon-kerberos /bin/bash

# Authenicate with kerberos
echo javagat | /usr/bin/kinit xenon 

# Clean up the run
docker rm -f xenon-kerberos
```

