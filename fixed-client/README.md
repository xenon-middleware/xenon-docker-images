Image which will run the [Xenon](http://nlesc.github.io/Xenon/) fixed client environment tests.

Will startup Docker containers to test against.

# Build with:

```bash
cd xenon-fixed-client
docker build -t xenonmiddleware/fixed-client .
```

# Run with

To run the [Xenon fixed client environment tests](https://github.com/NLeSC/Xenon/blob/master/TESTING.md#fixed-client-environment-tests) run from Xenon repo root dir run with:

```bash
cd Xenon
docker run \
    --env MYUID=$UID \
    --network host \
    --volume $HOME/.gradle:/home/xenon/.gradle \
    --volume $HOME/.m2:/home/xenon/.m2 \
    --volume /var/run/docker.sock:/var/run/docker.sock \
    --volume $PWD:/code \
    --tty --interactive --rm \
    --name=xenon-fixed-client \
    xenonmiddleware/fixed-client
```
The above command breaks down as follows:

```bash
docker run \
    # The tests will output files which will be owned by my UID (the UID outside of the container)
    --env MYUID=$UID \
    # Tests will start other Docker containers, by using network=host the ports of sibling containers (slurm, sftp, etc.) are accessible by this Docker container.
    --network host \
    # Use gradle cache from outside container, so no new downloads are required
    --volume $HOME/.gradle:/home/xenon/.gradle \
    # Use maven cache from outside container, so no new downloads are required. (Maven cache is used by gradle plugins)
    --volume $HOME/.m2:/home/xenon/.m2 \
    # Tests will start other Docker containers, so will use the local Docker daemon inside this container
    --volume /var/run/docker.sock:/var/run/docker.sock \
    # Code on which to run the gradle test task
    --volume $PWD:/code \
    --tty --interactive --rm \
    --name=xenon-fixed-client \
    xenonmiddleware/fixed-client
```

By default, xenonmiddleware/fixed-client will run `./gradlew --no-daemon fixedClientEnvironmentTest`; to run a different command, append the CMD you want to run, for example:

```bash
cd Xenon
docker run \
    --env MYUID=$UID \
    --network host \
    --volume $HOME/.gradle:/home/xenon/.gradle \
    --volume $HOME/.m2:/home/xenon/.m2 \
    --volume /var/run/docker.sock:/var/run/docker.sock \
    --volume $PWD:/code \
    --tty --interactive --rm \
    --name=xenon-fixed-client \
    xenonmiddleware/fixed-client \
    ./gradlew --no-daemon fixedClientEnvironmentTest --tests=*agent*
```

This will only run tests which contain the string `agent` in their package or class name.
