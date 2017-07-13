cd fixture
docker build --tag fixture .
cd ..

cd ssh
docker build --tag ssh .
cd ..

cd munge
docker build --tag munge .
cd ..

cd slurm-abstract
docker build --tag slurm-abstract .
cd ..

cd supervisor
docker build --tag supervisor .
cd ..

#cd slurm-14
#docker build --tag slurm-14 .
#cd ..
#
#cd slurm-15
#docker build --tag slurm-15 .
#cd ..

cd slurm-16
docker build --tag slurm-16 .
cd ..

cd slurm-17
docker build --tag slurm-17 .
cd ..

