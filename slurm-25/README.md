# Slurm 25

Features:

- [Slurm batch scheduler](https://slurm.schedmd.com/) version 25
- A Cluster `mycluster` with two queues/partitions: `mypartition` and `otherpartition`.
- SSH access for user `xenon` with password `javagat`
- Run [Slurm REST API](https://slurm.schedmd.com/rest_quickstart.html#basic_usage) on port 6820

## Run

```bash
docker run  --privileged -p 10022:22 ghcr.io/xenon-middleware/slurm:25
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
# Print api spec (paste output in https://editor.swagger.io/ for more human readable format)
slurmrestd --generate-openapi-spec
# In progress jobs
wget --header="X-SLURM-USER-TOKEN:${SLURM_JWT}" -q -S -O - http://localhost:6820/slurm/v0.0.43/jobs
# Completed jobs
wget --header="X-SLURM-USER-TOKEN:${SLURM_JWT}" -q -S -O - http://localhost:6820/slurmdb/v0.0.43/jobs
```

## Build

To build we reuse the Dockerfile and context from [../slurm-23](../slurm-23/) and just pass a different version.

```shell
cd ../slurm-23
docker build --progress=plain --build-arg SLURM_VERSION=25.05.4 -t ghcr.io/xenon-middleware/slurm:25.05.4 .
docker push ghcr.io/xenon-middleware/slurm:25.05.4
# Once working, also tag as 25
docker tag ghcr.io/xenon-middleware/slurm:25.05.4 ghcr.io/xenon-middleware/slurm:25
docker push ghcr.io/xenon-middleware/slurm:25
```
