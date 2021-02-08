Docker image for [Son of Grid Engine batch scheduler](https://arc.liv.ac.uk/trac/SGE) v8.1.9.

Used as scheduler in integration tests of [Xenon](nlesc.github.io/Xenon/) Java library.

# Configuration

* SSH server on port 22
* Posix account `xenon` with password `javagat` and [ssh-keys](https://github.com/NLeSC/xenon-docker-images/tree/master/unsafe-ssh-keys).
* Son of grid engine
    * `default` and `slow` queues
    * `default` is default queue
    * Single compute node with same number of processors as host machine
    * `bi`, `fillup`, `round` and `smp` as parallel environments

# Build with

```bash
cd gridengine
docker build -t xenonmiddleware/sonofgridengine .
```

# Run with

```bash
docker run --detach --publish 10022:22 --name=xenon-sonofgridengine xenonmiddleware/sonofgridengine

# use password javagat
ssh -p 10022 xenon@localhost

# submit
echo 'printenv' | qsub
# should write output of `printenv` command to ./STDIN.o1 file

# view the queue
qstat -f

# Clean up
exit
docker rm -f xenon-sonofgridengine
```

A docker-compose config file called [docker-compose.yml](https://github.com/NLeSC/xenon-docker-images/blob/master/xenon-sonofgridengine/docker-compose.yml) is included in the repository.

