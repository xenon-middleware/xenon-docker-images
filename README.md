# xenon-docker-images
testing out a different slurm configuration

**Building the Docker images**

```bash
cd lubuntu-fixture
docker build --tag lubuntu-fixture .
cd ..

cd lubuntu-ssh
docker build --tag lubuntu-ssh .
cd ..

cd lubuntu-munge
docker build --tag lubuntu-munge .
cd ..

cd lubuntu-slurm
docker build --tag lubuntu-slurm .
cd ..

cd lubuntu-supervisor
docker build --tag lubuntu-supervisor .
cd ..

```


**Running the final product (interactive)**

```bash
docker run --tty --interactive lubuntu-supervisor bash
```

**Running the final product (background)**

```bash
docker run --detach --publish 10022:22 lubuntu-supervisor
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

# let supervisor start munged
service supervisor start munged
```


