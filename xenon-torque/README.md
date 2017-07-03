Docker container with ssh server, to run the xenon torque adaptor integration tests against.

Build with:

```bash
cd xenon-torque
docker build -t nlesc/xenon-torque .
```

Run with:

```bash
docker run --detach --name xenon-torque --hostname xenon-torque --publish 10022:22 --privileged nlesc/xenon-torque

# use password javagat
ssh -p 10022 xenon@localhost

# view the queue
qstat -q


# Clean up
docker rm -f xenon-torque
```

Note: Torque does not like hostname that start with number, so hostname is required

