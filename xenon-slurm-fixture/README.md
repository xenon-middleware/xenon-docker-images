**Building the Docker image**

```bash
docker build --tag nlesc/xenon-slurm-fixture .
```

This docker image provides some file system fixtures for 
[Xenon](https://github.com/NLeSC/Xenon)'s 
[SLURM](https://slurm.schedmd.com/) integration tests.

This docker image is an intermediate image; as such it is not meant to be run by
itself. For docker images that can run by themselves, and which inherit from 
this image, refer to:

- nlesc/xenon-slurm-14
- nlesc/xenon-slurm-15
- nlesc/xenon-slurm-16
- nlesc/xenon-slurm-17



