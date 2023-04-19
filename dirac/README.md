# Dirac

Follows the instructions from:
https://dirac.readthedocs.io/en/latest/AdministratorGuide/Tutorials/basicTutoSetup.html
and
https://github.com/DIRACGrid/DIRAC/blob/integration/docs/source/AdministratorGuide/Tutorials/basicTutoSetup.sh
and integration test scripts.

## Build

```shell
docker build -t xenonmiddleware/dirac:latest --progress plain --build-arg BUILDKIT_SANDBOX_HOSTNAME=dirac-tuto .
```
(During build need to interact with services which require host certificates. The `--build-arg BUILDKIT_SANDBOX_HOSTNAME=dirac-tuto` fixes the hostname so the certificate validation works.)

## Run

```shell
docker run --privileged --hostname dirac-tuto --name dirac-tuto xenonmiddleware/dirac:latest
```
(to run apptainer containers requires the --privileged flag)

For debugging:

```shell
docker run --privileged -ti --rm --hostname dirac-tuto --name dirac-tuto --entrypoint bash xenonmiddleware/dirac:latest
# In another terminal
docker exec -ti dirac-tuto bash
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

Job stuck on `JobID=1 ApplicationStatus=Unknown; MinorStatus=Pilot Agent Submission; Status=Waiting; Site=ANY;` possibly due to `startup/WorkloadManagement_SiteDirector/log/current` error
2023-04-19 08:23:05 UTC WorkloadManagement/SiteDirector WARN: Issue getting socket: <DIRAC.Core.DISET.private.Transports.M2SSLTransport.SSLTransport object at 0x7fa6ebf31220> : ('dips', 'dirac-tuto', 9152, 'Framework/ProxyManager') : [Errno 111] Connection refused:ConnectionRefusedError(111, 'Connection refused')
2023-04-19 08:23:05 UTC WorkloadManagement/SiteDirector WARN: Non-responding URL temporarily banned dips://dirac-tuto:9152/Framework/ProxyManager
2023-04-19 08:23:05 UTC WorkloadManagement/SiteDirector INFO: Retry connection : 1 to dips://dirac-tuto:9152/Framework/ProxyManager
2023-04-19 08:23:05 UTC WorkloadManagement/SiteDirector INFO: Waiting 2.000000 seconds before retry all service(s)
2023-04-19 08:23:07 UTC WorkloadManagement/SiteDirector WARN: Issue getting socket: <DIRAC.Core.DISET.private.Transports.M2SSLTransport.SSLTransport object at 0x7fa6ebed4d90> : ('dips', 'dirac-tuto', 9152, 'Framework/ProxyManager') : [Errno 111] Connection refused:ConnectionRefusedError(111, 'Connection refused')
2023-04-19 08:23:07 UTC WorkloadManagement/SiteDirector WARN: Non-responding URL temporarily banned dips://dirac-tuto:9152/Framework/ProxyManager
2023-04-19 08:23:07 UTC WorkloadManagement/SiteDirector INFO: Retry connection : 2 to dips://dirac-tuto:9152/Framework/ProxyManager
2023-04-19 08:23:07 UTC WorkloadManagement/SiteDirector INFO: Waiting 2.000000 seconds before retry all service(s)
...
2023-04-19 08:23:09 UTC WorkloadManagement/SiteDirector WARN: No voms attribute assigned to group dirac_user when requested pilot proxy
2023-04-19 08:23:09 UTC WorkloadManagement/SiteDirector WARN: Could not get stored proxy strength /C=ch/O=DIRAC/OU=DIRAC CI/CN=ciuser, dirac_user: {'OK': False, 'Errno': 1101, 'Message': "Can't find proxy ( 1101 : /C=ch/O=DIRAC/OU=DIRAC CI/CN=ciuser@dirac_user has no proxy registered)", 'rpcStub': [['Framework/ProxyManager', {'timeout': 600, 'skipCACheck': False, 'keepAliveLapse': 150}], 'getStoredProxyStrength', ['/C=ch/O=DIRAC/OU=DIRAC CI/CN=ciuser', 'dirac_user', None]]}
2023-04-19 08:23:09 UTC WorkloadManagement/SiteDirector/WorkloadManagement/SiteDirector ERROR: Errors in updating pilot status:  Can't find proxy ( 1101 : Can't get proxy for 37800 seconds: Can't find proxy ( 1101 : /C=ch/O=DIRAC/OU=DIRAC CI/CN=ciuser@dirac_user has no proxy registered), try to generate new; Cannot generate proxy: No proxy providers found for "/C=ch/O=DIRAC/OU=DIRAC CI/CN=ciuser")

## WebApp

1. `docker cp dirac-tuto:/opt/dirac/user/certificate.p12 .`
2. Add certificate.p12 to browser
3. Add dirac-tuto to /etc/hosts of machine running the browser
4. Goto https://dirac-tuto:8443/DIRAC/s:MyDIRAC-Production/g:dirac_user/
