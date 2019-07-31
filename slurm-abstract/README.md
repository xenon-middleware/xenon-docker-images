**Building the Docker image**

```bash
docker build --tag xenonmiddleware/slurm-abstract .
```

This docker image provides the SLURM configuration for [Xenon](https://github.com/NLeSC/Xenon)'s [SLURM](https://slurm.schedmd.com/) integration tests, at least the part of the configuration that is common to SLURM 14-17. For example it prepares a slurm user, initializes files, and adds an example SLURM job script.

This docker image is an intermediate image; as such it is not meant to be run by itself. For docker images that can run by themselves, and which inherit from this image, refer to [xenonmiddleware/slurm](https://hub.docker.com/r/xenonmiddleware/slurm/).

