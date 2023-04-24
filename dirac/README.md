# Dirac

[DIRAC](https://diracgrid.org) is an interware, meaning a software framework for distributed computing.

The Dockerfile follows the instructions from:
https://dirac.readthedocs.io/en/latest/AdministratorGuide/Tutorials/basicTutoSetup.html
,
https://github.com/DIRACGrid/DIRAC/blob/integration/docs/source/AdministratorGuide/Tutorials/basicTutoSetup.sh
and integration test scripts.

## Run from GitHub container registry

Run image from https://github.com/xenon-middleware/xenon-docker-images/pkgs/container/dirac with:

```shell
docker run --privileged --hostname dirac-tuto ghcr.io/xenon-middleware/dirac:8.0.18
```
The `--privileged` flag is required to run apptainer containers inside Docker container.

The `--hostname` flag is required to fix the hostname so the certificate validation works. 

If you want to talk to the container from another machine you need to add the hostname to /etc/hosts of that machine.
This can be done with `docker-compose` see [../diracclient](diracclient/README.md) for an example.

## Configuration

* hostname: dirac-tuto
* host certificates: /opt/dirac/etc/grid-security/certificates
* setup: MyDIRAC-Production
* sites:
  * MyGrid.Site1.uk: 
    * storage element: StorageElementOne
    * pilot job + job
  * MyGrid.Site2.de: 
    * storage element: StorageElementTwo
* configuration server: dips://dirac-tuto:9135/Configuration/Server
* user 
  * name: diracuser
  * groups:
    * dirac_user: to upload/download files and submit jobs
    * dirac_admin: to change configuration
    * dirac_data: for pilot job
  * certificates: /home/diracuser/.globus
* web portal:
  * https://dirac-tuto:8443
  * user web certificate: /home/diracuser/.globus/certificate.p12
* CernVM File System:
  * root: /cvmfs
  * repository: /cvmfs/my.repo.name
  * read and writable by everyone
  * just a directory not a real CVMFS repository
* Apptainer
  * Computing element not configured
* monitoring: not installed or configured

## Build

```shell
docker build -t ghcr.io/xenon-middleware/dirac:8.0.18 --progress plain \
  --build-arg BUILDKIT_SANDBOX_HOSTNAME=dirac-tuto .
```
During build need to interact with services which require host certificates. 
The `--build-arg BUILDKIT_SANDBOX_HOSTNAME=dirac-tuto` fixes the hostname so the certificate validation works.
The `--progress plain` makes it possible to see all the output logs.

## Push

Make sure to [configure Docker to be able to push to GitHub container registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry#authenticating-to-the-container-registry).

```shell
docker push ghcr.io/xenon-middleware/dirac:8.0.18
docker tag ghcr.io/xenon-middleware/dirac:8.0.18 ghcr.io/xenon-middleware/dirac:latest
docker push ghcr.io/xenon-middleware/dirac:latest
```

## Test

First login to container with

```shell
docker exec -ti <id or name of container> bash
```

```shell
su diracuser
cd
. /opt/dirac/bashrc
dirac-proxy-init -g dirac_user
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
# Files retrieved and extracted in /home/diracuser/1
# Job output sandbox retrieved in /home/diracuser/1/
cat 1/StdOut
# total 4
# -rw-r--r-- 1 diracpilot diracpilot 604 Apr 21 12:08 job.info
```

## DIRAC web portal

The [DIRAC web portal](https://dirac.readthedocs.io/en/latest/UserGuide/WebPortalReference/Overview/index.html) can be accessed with:

1. `docker cp <id or name of container>:/home/diracuser/.globus/certificate.p12 .`
2. Add certificate.p12 to browser
3. Add dirac-tuto + ip of container (use `docker inspect` to get ip) to /etc/hosts of machine running the browser
4. Goto https://dirac-tuto:8443/DIRAC/s:MyDIRAC-Production/g:dirac_user/
   * Ignore host certificate warning