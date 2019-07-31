Docker container for [Torque batch scheduler](http://www.adaptivecomputing.com/products/open-source/torque/) v5.0.0

Used as scheduler in integration tests of [Xenon](nlesc.github.io/Xenon/) Java library.

# Configuration

* SSH server on port 22
* Posix account `xenon` with password `javagat` and [ssh-keys](https://github.com/NLeSC/xenon-docker-images/tree/master/unsafe-ssh-keys).
* Torque
    * `debug` and `batch` queues
    * `debug` is default queue
    * Single compute node with single processor

# Build with

```bash
cd xenon-torque
docker build -t xenonmiddleware/torque .
```

# Run with

```bash
docker run --detach --name xenon-torque --hostname xenon-torque --publish 10022:22 --cap-add SYS_RESOURCE xenonmiddleware/torque

# use password javagat
ssh -p 10022 xenon@localhost

# submit
echo 'printenv' | qsub
# should write output of `printenv` command to ./STDIN.o0 file

# view the queue
qstat

# Clean up
exit
docker rm -f xenon-torque
```

Note: Torque does not like hostname that start with number, so hostname is required

A docker-compose config file called [docker-compose.yml](https://github.com/NLeSC/xenon-docker-images/blob/master/xenon-torque/docker-compose.yml) is included in the repository.
