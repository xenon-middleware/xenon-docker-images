# Slurm 23

Features:

- [Slurm batch scheduler](https://slurm.schedmd.com/) version 23
- A Cluster `mycluster` with two queues/partitions: `mypartition` and `otherpartition`.
- SSH access for user `xenon` with password `javagat`
- Run [Slurm REST API](https://slurm.schedmd.com/rest_quickstart.html#basic_usage) on port 6820

## Run

```bash
docker run  --privileged -p 10022:22 ghcr.io/xenon-middleware/slurm:23
```
(privileged flag is needed becasue slurm needs cgroup and IPC permission)

(depending on your Docker setup, you might need to run with `--privileged --cgroupns=private` arguments)
(if you want to interact with the REST API outside container add `-p 6820:6820` arguments, 
you will need an user token which can be generated with the `scontrol token` command.)

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

### REST API

To interact with the Slurm REST API, you can use the following commands:

```bash
unset SLURM_JWT; export $(scontrol token)
# In progress jobs
wget --header="X-SLURM-USER-TOKEN:${SLURM_JWT}" -q -S -O - http://localhost:6820/slurm/v0.0.40/jobs
# Completed jobs
wget --header="X-SLURM-USER-TOKEN:${SLURM_JWT}" -q -S -O - http://localhost:6820/slurmdb/v0.0.40/jobs
```

## Build

```bash
docker build -t ghcr.io/xenon-middleware/slurm:23 .
```
