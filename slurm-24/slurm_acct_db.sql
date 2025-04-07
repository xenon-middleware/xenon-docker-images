create user 'slurm'@'localhost' identified by 'password';
grant all on slurm_acct_db.* TO 'slurm'@'localhost';
create database slurm_acct_db;
