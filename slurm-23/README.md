# Slurm 23

Features:
- Slurm batch scheduler version 23
- A Cluster ``mycluster`` with two queues/partitions: ``mypartition`` and ``otherpartition``.
- SSH access for user ``xenon`` with password ``javagat``

## Run

```bash
docker run -p 10022:22 ghcr.io/xenon-middleware/slurm:23
```
(depending on your Docker setup, you might need to run with `--privileged --cgroupns=private` arguments)

Once the container is running, you can log into it with (password is 'javagat'):

```bash
ssh -p 10022 xenon@localhost
```

You can then submit a job, e.g.:

```bash
srun /bin/hostname
```

Check the status with 

```bash
squeue
sacct
```

## Build

```bash
docker build -t ghcr.io/xenon-middleware/slurm:23 .
```