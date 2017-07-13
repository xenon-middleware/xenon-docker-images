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

