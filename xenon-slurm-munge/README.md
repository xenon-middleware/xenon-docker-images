**Building the Docker image**

```bash
docker build --tag nlesc/xenon-slurm-munge .
```

This docker image provides the [MUNGE](https://dun.github.io/munge/) authentication service for [Xenon](https://github.com/NLeSC/Xenon)'s [SLURM](https://slurm.schedmd.com/) integration tests.

This docker image is an intermediate image; as such it is not meant to be run by itself. For docker images that can run by themselves, and which inherit from this image, refer to [nlesc/xenon-slurm](https://hub.docker.com/r/nlesc/xenon-slurm/).

