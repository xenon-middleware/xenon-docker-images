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
Added `-ddd` to /opt/dirac/startup/WorkloadManagement_SiteDirector to see where it goes wrong

```
2023-04-19 12:54:10 UTC WorkloadManagement/SiteDirector [140103544424256] DEBUG: New connection -> 172.17.0.2:9145
2023-04-19 12:54:10 UTC WorkloadManagement/SiteDirector/WorkloadManagement/SiteDirector [140103544424256] VERBOSE: Checking overall TQ availability with requirements
2023-04-19 12:54:10 UTC WorkloadManagement/SiteDirector/WorkloadManagement/SiteDirector [140103544424256] VERBOSE: {'Setup': 'MyDIRAC-Production', 'CPUTime': 9999999, 'Community': 'tutoVO', 'OwnerGroup': ['dirac_user', 'dirac_data', 'dirac_prod'], 'Site': ['MyGrid.Site1.uk'], 'Tag': [], 'NumberOfProcessors': 1, 'MaxRAM': 2048}
2023-04-19 12:54:10 UTC WorkloadManagement/SiteDirector/DIRAC.Core.Tornado.Client.ClientSelector [140103544424256] DEBUG: Trying to autodetect client for WorkloadManagement/Matcher
2023-04-19 12:54:10 UTC WorkloadManagement/SiteDirector/DIRAC.Core.Tornado.Client.ClientSelector [140103544424256] DEBUG: URL resolved: dips://dirac-tuto:9170/WorkloadManagement/Matcher
2023-04-19 12:54:10 UTC WorkloadManagement/SiteDirector [140103544424256] DEBUG: Discovering URL for service WorkloadManagement/Matcher -> dips://dirac-tuto:9170/WorkloadManagement/Matcher
2023-04-19 12:54:10 UTC WorkloadManagement/SiteDirector [140103544424256] DEBUG: Trying to connect to: dips://dirac-tuto:9170/WorkloadManagement/Matcher
2023-04-19 12:54:10 UTC WorkloadManagement/SiteDirector [140103544424256] DEBUG: Connected to: dips://dirac-tuto:9170/WorkloadManagement/Matcher
2023-04-19 12:54:10 UTC WorkloadManagement/SiteDirector [140103544424256] DEBUG: New connection -> 172.17.0.2:9170
2023-04-19 12:54:10 UTC WorkloadManagement/SiteDirector/WorkloadManagement/PilotAgentsDB [140103544424256] DEBUG: _query: SELECT COUNT(PilotID) from PilotAgents    WHERE `TaskQueueID` IN ( "1" ) AND `Status` IN ( "Submitted", "Waiting", "Scheduled" ) 
2023-04-19 12:54:10 UTC WorkloadManagement/SiteDirector/WorkloadManagement/SiteDirector [140103544424256] INFO: Total jobs : number of task queues : number of waiting pilots 1 : 1 : 0
2023-04-19 12:54:10 UTC WorkloadManagement/SiteDirector/WorkloadManagement/SiteDirector [140103544424256] DEBUG: Going to try to submit some pilots
2023-04-19 12:54:10 UTC WorkloadManagement/SiteDirector/WorkloadManagement/SiteDirector [140103544424256] VERBOSE: Queues treated dirac-tuto_queue
2023-04-19 12:54:10 UTC WorkloadManagement/SiteDirector/WorkloadManagement/SiteDirector [140103544424256] VERBOSE: Evaluating queue dirac-tuto_queue
2023-04-19 12:54:10 UTC WorkloadManagement/SiteDirector/DIRAC.Core.Tornado.Client.ClientSelector [140103544424256] DEBUG: Trying to autodetect client for WorkloadManagement/Matcher
2023-04-19 12:54:10 UTC WorkloadManagement/SiteDirector/DIRAC.Core.Tornado.Client.ClientSelector [140103544424256] DEBUG: URL resolved: dips://dirac-tuto:9170/WorkloadManagement/Matcher
2023-04-19 12:54:10 UTC WorkloadManagement/SiteDirector [140103544424256] DEBUG: Discovering URL for service WorkloadManagement/Matcher -> dips://dirac-tuto:9170/WorkloadManagement/Matcher
2023-04-19 12:54:10 UTC WorkloadManagement/SiteDirector [140103544424256] DEBUG: Trying to connect to: dips://dirac-tuto:9170/WorkloadManagement/Matcher
2023-04-19 12:54:10 UTC WorkloadManagement/SiteDirector [140103544424256] DEBUG: Connected to: dips://dirac-tuto:9170/WorkloadManagement/Matcher
2023-04-19 12:54:10 UTC WorkloadManagement/SiteDirector [140103544424256] DEBUG: New connection -> 172.17.0.2:9170
2023-04-19 12:54:10 UTC WorkloadManagement/SiteDirector/WorkloadManagement/SiteDirector [140103544424256] VERBOSE: No matching TQs found for {'Site': 'MyGrid.Site1.uk', 'WaitingToRunningRatio': 0.5, 'MaxWaitingJobs': '10', 'MaxTotalJobs': '5', 'SharedArea': '$HOME', 'BatchOutput': 'data', 'BatchError': '/home/diracpilot/localsite/error', 'ExecutableArea': '/home/diracpilot/localsite/submission', 'InfoArea': 'info', 'WorkArea': 'work', 'CEType': 'SSH', 'SSHHost': 'dirac-tuto', 'SSHUser': 'diracpilot', 'SSHPassword': 'password', 'SSHType': 'ssh', 'CPUTime': 40000, 'BundleProxy': 'True', 'RemoveOutput': 'True', 'Queue': 'queue', 'GridCE': 'dirac-tuto', 'GridEnv': '', 'Setup': 'MyDIRAC-Production', 'Tag': [], 'RequiredTag': [], 'BatchSystem': 'Host', 'Community': 'tutoVO', 'OwnerGroup': ['dirac_user', 'dirac_data', 'dirac_prod']}
2023-04-19 12:54:10 UTC WorkloadManagement/SiteDirector/WorkloadManagement/SiteDirector [140103544424256] DEBUG: 0 pilotsWeMayWantToSubmit are eligible for dirac-tuto_queue queue
2023-04-19 12:54:10 UTC WorkloadManagement/SiteDirector/WorkloadManagement/SiteDirector [140103544424256] DEBUG: ...so skipping dirac-tuto_queue
2023-04-19 12:54:10 UTC WorkloadManagement/SiteDirector/WorkloadManagement/SiteDirector [140103544424256] INFO: Total number of pilots submitted in this cycle 0
```

I did not expect `No matching TQs found` from src/DIRAC/WorkloadManagementSystem/Agent/SiteDirector.py

## WebApp

1. `docker cp dirac-tuto:/home/diracuser/.globus/certificate.p12 .`
2. Add certificate.p12 to browser
3. Add dirac-tuto to /etc/hosts of machine running the browser
4. Goto https://dirac-tuto:8443/DIRAC/s:MyDIRAC-Production/g:dirac_user/
