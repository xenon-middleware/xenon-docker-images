Docker container for [SLURM](https://slurm.schedmd.com/) batch scheduler v15.08

#Build with

```bash
docker build --tag nlesc/xenon-slurm:15.08 .
```

#Run with

Slurm requires a MySQL database for accounting. Use [docker-compose](https://docs.docker.com/compose/)
to start mysql container and the slurm container.


```bash

docker run --detach --publish 10022:22 --name=xenon-slurm-15.08 nlesc/xenon-slurm:15.08

# Test with (password is 'javagat')
ssh -p 10022 xenon@localhost
```
