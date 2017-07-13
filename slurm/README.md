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

cd slurm-14
docker build --tag slurm-14 .
cd ..

cd slurm-15
docker build --tag slurm-15 .
cd ..

cd slurm-16
docker build --tag slurm-16 .
cd ..

cd slurm-17
docker build --tag slurm-17 .
cd ..

```

**Running the final product (interactive)**

```bash
docker run --tty --interactive slurm-17 bash
```

**Running the final product (background)**

```bash
docker run --detach --publish 10022:22 slurm-17
```

Once the container is running, you can log into it with:

```bash
ssh -p 10022 xenon@localhost
```


