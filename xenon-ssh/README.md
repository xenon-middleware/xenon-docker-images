Docker container with ssh server, to run the xenon ssh filesystem and ssh
scheduler integration tests against.

Build with

```bash
cd xenon-ssh
docker build -t nlesc/xenon-ssh .
```

Run with:

```bash
docker run --detach --name=xenon-ssh --hostname xenon-ssh nlesc/xenon-ssh

# Get containers ip with
XENON_SSH_LOCATION=$(docker inspect -f "{{ .NetworkSettings.IPAddress }}" xenon-ssh)

# Login with private key
chmod 600 ../unsafe-ssh-keys/id_rsa
ssh -i ../unsafe-ssh-keys/id_rsa xenon@$XENON_SSH_LOCATION

# Login with password javagat
ssh xenon@$XENON_SSH_LOCATION

# Clean up the run
docker rm -f xenon-ssh
```
