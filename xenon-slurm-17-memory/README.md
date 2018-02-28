This container provides a [SLURM](https://github.com/SchedMD/slurm/) installation. 

**Available tags**

| tag | Dockerfile (on GitHub)|
|---|---|
| 17, latest  | [xenon-slurm-17/Dockerfile](https://github.com/NLeSC/xenon-docker-images/blob/master/xenon-slurm-17/Dockerfile) |
| 17-mem | [xenon-slurm-17/Dockerfile](https://github.com/NLeSC/xenon-docker-images/blob/master/xenon-slurm-17-memory/Dockerfile) |
| 16  | [xenon-slurm-16/Dockerfile](https://github.com/NLeSC/xenon-docker-images/blob/master/xenon-slurm-16/Dockerfile) |
| 15  | [xenon-slurm-15/Dockerfile](https://github.com/NLeSC/xenon-docker-images/blob/master/xenon-slurm-15/Dockerfile) |
| 14  | [xenon-slurm-14/Dockerfile](https://github.com/NLeSC/xenon-docker-images/blob/master/xenon-slurm-14/Dockerfile) |

**Image description**

The image includes:

- A Cluster ``mycluster`` with two queues/partitions: ``mypartition`` and ``otherpartition``. Running an ``sinfo`` inside the container yields:
    
    ```text
    $ sinfo
    PARTITION      AVAIL  TIMELIMIT  NODES  STATE NODELIST
    mypartition*      up   infinite      5   idle node-[0-4]
    otherpartition    up   infinite      3   idle node-[0-2]
    ```
    
- SSH access for user ``xenon`` with password ``javagat``
- an example SLURM job script, ``/home/xenon/test-slurm.job``
- file system fixtures for integration testing, as follows:
    
    ```text
    -rw-r--r-- 1 xenon xenon 12 Jul 25 14:05 file0
    -rw-r--r-- 1 xenon xenon  0 Jul 25 14:05 file1
    lrwxrwxrwx 1 xenon xenon 47 Jul 25 14:05 link0 -> /home/xenon/filesystem-test-fixture/links/file0
    lrwxrwxrwx 1 xenon xenon 47 Jul 25 14:05 link1 -> /home/xenon/filesystem-test-fixture/links/file1
    lrwxrwxrwx 1 xenon xenon 47 Jul 25 14:05 link2 -> /home/xenon/filesystem-test-fixture/links/file2
    lrwxrwxrwx 1 xenon xenon 47 Jul 25 14:05 link3 -> /home/xenon/filesystem-test-fixture/links/link0
    lrwxrwxrwx 1 xenon xenon 47 Jul 25 14:05 link4 -> /home/xenon/filesystem-test-fixture/links/link2
    lrwxrwxrwx 1 xenon xenon 47 Jul 25 14:05 link5 -> /home/xenon/filesystem-test-fixture/links/link6
    lrwxrwxrwx 1 xenon xenon 47 Jul 25 14:05 link6 -> /home/xenon/filesystem-test-fixture/links/link5
    ```
  
**Building the Docker image**

```bash
docker build --tag nlesc/xenon-slurm:<tag> .
```

**Running the Docker container (background)**

```bash
docker run --detach --publish 10022:22 nlesc/xenon-slurm:<tag>
```

Once the container is running, you can log into it with (password is 'javagat'):

```bash
ssh -p 10022 xenon@localhost
```

You can then submit a job, e.g.:

```bash
srun /bin/hostname
```

or you can submit the example job script

```bash
sbatch /home/xenon/test-slurm.job
```

check the status with 

```bash
squeue
sacct
```




