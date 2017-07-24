cd xenon-fixture
docker build --tag xenon-fixture .
cd ..

cd xenon-ssh
docker build --tag xenon-ssh .
cd ..

cd xenon-munge
docker build --tag xenon-munge .
cd ..

cd xenon-mysql
docker build --tag xenon-mysql .
cd ..

cd xenon-slurm-abstract
docker build --tag xenon-slurm-abstract .
cd ..

cd xenon-supervisor
docker build --tag xenon-supervisor .
cd ..

cd xenon-slurm-14
docker build --tag xenon-slurm:14 .
cd ..

cd xenon-slurm-15
docker build --tag xenon-slurm:15 .
cd ..

cd xenon-slurm-16
docker build --tag xenon-slurm:16 .
cd ..

cd xenon-slurm-17
docker build --tag xenon-slurm:17 .
cd ..

