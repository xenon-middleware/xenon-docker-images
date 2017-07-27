This container provides a SLURM 14 ([tar.gz](https://github.com/SchedMD/slurm/archive/slurm-14-11-11-1.tar.gz)) installation. It includes:

- MySQL accounting; root password is ``xenon-slurm-pw``
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
docker build --tag nlesc/xenon-slurm:14 .
```

**Running the Docker container (background)**

```bash
docker run --detach --publish 10022:22 nlesc/xenon-slurm:14
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
