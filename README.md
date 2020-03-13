# About this Repo

Collection of Dockerfiles used for integration tests of [xenon](https://github.com/xenonmiddleware/xenon) and it's derivatives.

Each sub-directory contains a Dockerfile and optionally a docker-compose file for a different file system or batch schedulers.

The docker images are registered as automated builds in the [xenon middleware Docker Hub organization](https://hub.docker.com/u/xenonmiddleware/).

## Local build

All images can be build locally using [boatswain](https://github.com/nlesc-sherlock/boatswain) by running:

```sh
pip install boatswain
boatswain build
```

To build only a single image use

```sh
boatswain build slurm:16
```
