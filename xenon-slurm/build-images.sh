cd xenon-fixture
docker build --tag nlesc/xenon-fixture .
cd ..

cd xenon-supervisor
docker build --tag nlesc/xenon-supervisor .
cd ..

cd xenon-ssh
docker build --tag nlesc/xenon-ssh .
cd ..

cd xenon-munge
docker build --tag nlesc/xenon-munge .
cd ..

cd xenon-mysql
docker build --tag nlesc/xenon-mysql .
cd ..

cd xenon-slurm-abstract
docker build --tag nlesc/xenon-slurm-abstract .
cd ..

cd xenon-slurm-14
docker build --tag nlesc/xenon-slurm:14 .
cd ..

cd xenon-slurm-15
docker build --tag nlesc/xenon-slurm:15 .
cd ..

cd xenon-slurm-16
docker build --tag nlesc/xenon-slurm:16 .
cd ..

cd xenon-slurm-17
docker build --tag nlesc/xenon-slurm:17 .
cd ..

