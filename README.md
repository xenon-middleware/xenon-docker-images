# About this Repo

This is the Git repo used for integration tests of [Xenon](https://github.com/NLeSC/Xenon).

Each sub-directory contains a Dockerfile and optionally a docker-compose file for a different file system or batch schedulers.

The docker images are registered as automated builds in the [NLeSC Docker Hub organization](https://hub.docker.com/u/nlesc/).

## Local build

All images can be build locally using [boatswain](https://github.com/nlesc-sherlock/boatswain) by running:
```bash
pip install boatswain
boatswain build
```

To build only a single image use
```
boatswain build xenon-slurm
``
