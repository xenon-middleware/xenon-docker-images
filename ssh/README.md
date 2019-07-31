Docker container with ssh server, to run the xenon ssh filesystem and ssh
scheduler integration tests against.

### Build with

```bash
cd ssh
docker build -t xenonmiddleware/ssh .
```

### Run with

```bash
docker run --detach --name=xenon-ssh --hostname xenon-ssh --publish 10022:22 xenonmiddleware/ssh

# Login with private key
chmod 600 ../unsafe-ssh-keys/id_rsa
ssh -p 10022 -i ../unsafe-ssh-keys/id_rsa xenon@localhost

# Login with password javagat
ssh -p 10022 xenon@localhost

# Clean up the run
docker rm -f xenon-ssh
```
