# Dirac

Follows the instructions from:
https://dirac.readthedocs.io/en/latest/AdministratorGuide/Tutorials/basicTutoSetup.html
and
https://github.com/DIRACGrid/DIRAC/blob/integration/docs/source/AdministratorGuide/Tutorials/basicTutoSetup.sh
and integration test scripts.

## Run from GHCR

```shell
docker run --privileged --hostname dirac-tuto --name dirac-tuto ghcr.io/xenon-middleware/dirac:latest
```

## Build

```shell
docker build -t ghcr.io/xenon-middleware/dirac:latest --progress plain --build-arg BUILDKIT_SANDBOX_HOSTNAME=dirac-tuto .
```
(During build need to interact with services which require host certificates. The `--build-arg BUILDKIT_SANDBOX_HOSTNAME=dirac-tuto` fixes the hostname so the certificate validation works.)

## Run

```shell
docker run --privileged --hostname dirac-tuto --name dirac-tuto ghcr.io/xenon-middleware/dirac:latest
```
(to run apptainer containers requires the --privileged flag)

For debugging:

```shell
docker run --privileged -ti --rm --hostname dirac-tuto --name dirac-tuto --entrypoint bash ghcr.io/xenon-middleware/dirac:latest
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
```

Job stuck on `JobID=1 ApplicationStatus=Unknown; MinorStatus=Pilot Agent Submission; Status=Waiting; Site=ANY;` possibly due after
Added `-ddd` to /opt/dirac/startup/WorkloadManagement_SiteDirector and WorkflowManagement_Match and `sv restart <service>` to see where it goes wrong .

In /home/diracpilot/localsite/output/334F7FCD.out
```
2023-04-21 06:12:53 UTC INFO     Launching dirac-pilot script from /home/diracpilot/shared/work/334F7FCD/DIRAC_PpnOFQpilot
2023-04-21 06:12:53 UTC INFO     But first unpacking pilot files
2023-04-21 06:12:53 UTC INFO     Getting the pilot files from dirac-tuto:8443
Trying https://dirac-tuto:8443
2023-04-21 06:12:53 UTC ERROR    https://dirac-tuto:8443 unreacheable (this is normal!)
2023-04-21 06:12:53 UTC ERROR    HTTP Error 404: Not Found
...
2023-04-21 06:12:53 UTC ERROR    https://dirac-tuto:8443/pilot unreacheable (this is normal!)
2023-04-21 06:12:53 UTC ERROR    HTTP Error 404: Not Found
```
Look at PilotSyncAgent how /home/dirac/webRoot/www/pilot is filled.

## WebApp

1. `docker cp dirac-tuto:/home/diracuser/.globus/certificate.p12 .`
2. Add certificate.p12 to browser
3. Add dirac-tuto to /etc/hosts of machine running the browser
4. Goto https://dirac-tuto:8443/DIRAC/s:MyDIRAC-Production/g:dirac_user/
