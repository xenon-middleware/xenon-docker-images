# xenon-docker-images
testing out a different slurm configuration

**Building the Docker images**

```bash
cd fixture
docker build --tag fixture .
cd ..

cd ssh
docker build --tag ssh .
cd ..

cd munge
docker build --tag munge .
cd ..

cd slurm
docker build --tag slurm .
cd ..

cd supervisor
docker build --tag supervisor .
cd ..

```


**Running the final product (interactive)**

```bash
docker run --tty --interactive supervisor bash
```

**Running the final product (background)**

```bash
docker run --detach --publish 10022:22 supervisor
```

Once the container is running, you can log into it with:

```bash
ssh -p 10022 xenon@localhost
```


**sysadmin command cheatsheet**

```bash
# ask about the running daemons
service --status-all

# ask supervisor for its status
service supervisor status

# start supervisor
service supervisor start &

# once supervisorctl has started,
# list the services it knows about and their status
supervisorctl -i
```


