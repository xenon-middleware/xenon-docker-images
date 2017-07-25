**Building the Docker image**

```bash
docker build --tag nlesc/xenon-slurm:17 .
```

**Running the final product (interactive)**

```bash
docker run --tty --interactive nlesc/xenon-slurm:17 bash
```

**Running the final product (background)**

```bash
docker run --detach --publish 10022:22 nlesc/xenon-slurm:17
```

Once the container is running, you can log into it with (password is 'javagat'):

```bash
ssh -p 10022 xenon@localhost
```

