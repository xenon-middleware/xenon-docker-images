# Dirac

[DIRAC](https://diracgrid.org) is an interware, meaning a software framework for distributed computing.

Follows the instructions from:
https://dirac.readthedocs.io/en/latest/AdministratorGuide/Tutorials/basicTutoSetup.html
and
https://github.com/DIRACGrid/DIRAC/blob/integration/docs/source/AdministratorGuide/Tutorials/basicTutoSetup.sh
and integration test scripts.

Container image at https://github.com/xenon-middleware/xenon-docker-images/pkgs/container/dirac .

## Run from GHCR

```shell
docker run --privileged --hostname dirac-tuto --name dirac-tuto ghcr.io/xenon-middleware/dirac:8.0.18
```

## Configuration

* hostname: dirac-tuto
* host certificates: /opt/dirac/etc/grid-security/certificates
* setup: MyDIRAC-Production
* Configuration server: dips://dirac-tuto:9135/Configuration/Server
* user 
  * name: diracuser
  * groups:
    * dirac_user: to upload/download files and submit jobs
    * dirac_admin: to change configuration
    * dirac_data: for pilot job
  * certificates: /home/diracuser/.globus
* WebApp:
  * https://dirac-tuto:8443
  * user web certificate: /home/diracuser/.globus/certificate.p12
* CernVM File System:
  * root: /cvmfs
  * repository: /cvmfs/my.repo.name
  * writable by everyone
  * just a directory not a real CVMFS repository
* Apptainer
  * Computing element not configured

## Build

```shell
docker build -t ghcr.io/xenon-middleware/dirac:8.0.18 --progress plain --build-arg BUILDKIT_SANDBOX_HOSTNAME=dirac-tuto .
```
(During build need to interact with services which require host certificates. The `--build-arg BUILDKIT_SANDBOX_HOSTNAME=dirac-tuto` fixes the hostname so the certificate validation works.)

## Run

```shell
docker run --privileged --hostname dirac-tuto --name dirac-tuto ghcr.io/xenon-middleware/dirac:8.0.18
```
(to run apptainer containers requires the --privileged flag)

For debugging:

```shell
docker run --privileged -ti --rm --hostname dirac-tuto --name dirac-tuto --entrypoint bash ghcr.io/xenon-middleware/dirac:8.0.18
# In another terminal
docker exec -ti dirac-tuto bash
/bin/entrypoint.sh &
```

## Test

```shell
su dirac
. bashrc
dirac-proxy-init -g dirac_user -C /opt/dirac/user/client.pem -K /opt/dirac/user/client.key
cat << EOL > Simple.jdl
JobName = "Simple_Job";
Executable = "/bin/ls";
Arguments = "-ltr";
StdOutput = "StdOut";
StdError = "StdErr";
OutputSandbox = {"StdOut","StdErr"};
EOL
dirac-wms-job-submit Simple.jdl
dirac-wms-job-status 1
# JobID=1 ApplicationStatus=Unknown; MinorStatus=Execution Complete; Status=Done; Site=MyGrid.Site1.uk;
dirac-wms-job-get-output 1
# Files retrieved and extracted in /opt/dirac/1
# Job output sandbox retrieved in /opt/dirac/1/
cat 1/StdOut
# total 4
# -rw-r--r-- 1 diracpilot diracpilot 604 Apr 21 12:08 job.info
```

## WebApp

1. `docker cp dirac-tuto:/home/diracuser/.globus/certificate.p12 .`
2. Add certificate.p12 to browser
3. Add dirac-tuto to /etc/hosts of machine running the browser
4. Goto https://dirac-tuto:8443/DIRAC/s:MyDIRAC-Production/g:dirac_user/
