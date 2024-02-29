# Slurm 23

Features:
- Slurm batch scheduler version 23
- A Cluster ``mycluster`` with two queues/partitions: ``mypartition`` and ``otherpartition``.
- SSH access for user ``xenon`` with password ``javagat``

## Run

```bash
# https://serverfault.com/questions/1053187/systemd-fails-to-run-in-a-docker-container-when-using-cgroupv2-cgroupns-priva
docker run  --privileged --cgroupns=private -p 10022:22 ghcr.io/xenon-middleware/slurm:23
```

Once the container is running, you can log into it with (password is 'javagat'):

```bash
ssh -p 10022 xenon@localhost
```

## Build

```bash
docker build -t ghcr.io/xenon-middleware/slurm:23 .
```