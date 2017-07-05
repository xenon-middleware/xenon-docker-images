Docker container for [SLURM](https://slurm.schedmd.com/) batch scheduler v15.08

# Build with

```bash
docker build --tag nlesc/xenon-slurm:15.08 .
```

# Run with

Slurm requires a MySQL database server for accounting. 
The MySQL database serve is expected to run with `mysql` as hostname and `xenon-slurm-pw` as mysql root password.
Use [docker-compose](https://docs.docker.com/compose/) to start mysql container and the slurm container.

```bash
docker-compose up -d
# Wait for the mysql and slurm containers to have healty status, check with
docker ps
# The container named 'slurm' exposes its containerPort 22; find out what corresponding hostPort is:
docker-compose port slurm 22
# this will produces something like `0.0.0.0:32796`,
# use 32796 as <SSH_PORT> and `localhost` as <SSH_HOSTNAME>
# if you get something else then `0.0.0.0` then use that as <SSH_HOSTNAME>
# Login with ssh using Test with (password is 'javagat')
ssh -p <SSH_PORT> xenon@<SSH_HOSTNAME>
# For alternative login use `docker-compose exec slurm setuser xenon bash` to login without ssh
# Submit a job
srun hostname
# Check job has completed
sacct
# Exit slurm ssh shell
exit
# Clean up
docker-compose kill
docker-compose rm -f
```
