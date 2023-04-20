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
Added `-ddd` to /opt/dirac/startup/WorkloadManagement_SiteDirector and WorkflowManagement_Match and `sv restart <service>` to see where it goes wrong .

```
2023-04-20 11:18:14 UTC WorkloadManagement/SiteDirector/dirac-tuto [139969674434368] INFO: Batch system class from module:  /opt/dirac/versions/v8.0.18-1681988721/Linux-x86_64/lib/python3.9/site-packages/DIRAC/Resources/Computing/BatchSystems/Host.py
2023-04-20 11:18:14 UTC WorkloadManagement/SiteDirector/dirac-tuto [139969674434368] INFO: Using queue:  queue
2023-04-20 11:18:14 UTC WorkloadManagement/SiteDirector/dirac-tuto [139969674434368] VERBOSE: Creating working directories on dirac-tuto
2023-04-20 11:18:14 UTC WorkloadManagement/SiteDirector/SSH [139969674434368] DEBUG: SSH command: ssh -q  -l diracpilot dirac-tuto "echo __DIRAC__; bash -c 'mkdir -p $HOME; mkdir -p /home/diracpilot/localsite/submission; mkdir -p $HOME/info; mkdir -p $HOME/data; mkdir -p /home/diracpilot/localsite/error; mkdir -p $HOME/work; '"
2023-04-20 11:18:15 UTC WorkloadManagement/SiteDirector/SSH [139969674434368] DEBUG: SSH command result {'OK': True, 'Value': (0, '\r\n__DIRAC__\r\n', '')}
2023-04-20 11:18:15 UTC WorkloadManagement/SiteDirector/dirac-tuto [139969674434368] VERBOSE: Uploading Host script to dirac-tuto
2023-04-20 11:18:15 UTC WorkloadManagement/SiteDirector/SSH [139969674434368] DEBUG: SSH copy command: /bin/sh -c "cat /opt/dirac/versions/v8.0.18-1681988721/Linux-x86_64/lib/python3.9/site-packages/DIRAC/Resources/Computing/BatchSystems/control_script.py | ssh -q  diracpilot@dirac-tuto 'cat > '$HOME/execute_batch'; chmod +x $HOME/execute_batch'"
...
2023-04-20 11:20:15 UTC WorkloadManagement/SiteDirector/WorkloadManagement/SiteDirector [139969674434368] INFO: Going to submit pilots (a maximum of 1 pilots to dirac-tuto_queue queue)
2023-04-20 11:20:15 UTC WorkloadManagement/SiteDirector/WorkloadManagement/SiteDirector [139969674434368] INFO: DIRAC project will be installed by pilots
2023-04-20 11:20:15 UTC WorkloadManagement/SiteDirector/WorkloadManagement/SiteDirector [139969674434368] VERBOSE: pilotOptions: -S MyDIRAC-Production --pythonVersion=3 -N dirac-tuto -Q queue -n MyGrid.Site1.uk -o '/LocalSite/SharedArea=$HOME'
2023-04-20 11:20:15 UTC WorkloadManagement/SiteDirector/SSH [139969674434368] DEBUG: SSH copy command: /bin/sh -c "cat /opt/dirac/work/WorkloadManagement/SiteDirector/DIRAC_8ut__z8j_pilotwrapper.py | ssh -q  diracpilot@dirac-tuto 'cat > /home/diracpilot/localsite/submission/DIRAC_8ut__z8j_pilotwrapper.py; chmod +x /home/diracpilot/localsite/submission/DIRAC_8ut__z8j_pilotwrapper.py'"
2023-04-20 11:20:15 UTC WorkloadManagement/SiteDirector/dirac-tuto [139969674434368] VERBOSE: CE submission command: bash --login -c 'python $HOME/execute_batch %7B%22Executable%22%3A%20%22/home/diracpilot/localsite/submission/DIRAC_8ut__z8j_pilotwrapper.py%22%2C%20%22NJobs%22%3A%201%2C%20%22SubmitOptions%22%3A%20%22%22%2C%20%22JobStamps%22%3A%20%5B%226ECC3B1F%22%5D%2C%20%22WholeNode%22%3A%20false%2C%20%22NumberOfProcessors%22%3A%201%2C%20%22NumberOfNodes%22%3A%20%221%22%2C%20%22Preamble%22%3A%20%22%22%2C%20%22NumberOfGPUs%22%3A%20null%2C%20%22Account%22%3A%20%22%22%2C%20%22BatchSystem%22%3A%20%22Host%22%2C%20%22Method%22%3A%20%22submitJob%22%2C%20%22SharedDir%22%3A%20%22%24HOME%22%2C%20%22OutputDir%22%3A%20%22%24HOME/data%22%2C%20%22ErrorDir%22%3A%20%22/home/diracpilot/localsite/error%22%2C%20%22WorkDir%22%3A%20%22%24HOME/work%22%2C%20%22InfoDir%22%3A%20%22%24HOME/info%22%2C%20%22ExecutionContext%22%3A%20%22SSHCE%22%2C%20%22User%22%3A%20%22diracpilot%22%2C%20%22Queue%22%3A%20%22queue%22%7D || python3 $HOME/execute_batch %7B%22Executable%22%3A%20%22/home/diracpilot/localsite/submission/DIRAC_8ut__z8j_pilotwrapper.py%22%2C%20%22NJobs%22%3A%201%2C%20%22SubmitOptions%22%3A%20%22%22%2C%20%22JobStamps%22%3A%20%5B%226ECC3B1F%22%5D%2C%20%22WholeNode%22%3A%20false%2C%20%22NumberOfProcessors%22%3A%201%2C%20%22NumberOfNodes%22%3A%20%221%22%2C%20%22Preamble%22%3A%20%22%22%2C%20%22NumberOfGPUs%22%3A%20null%2C%20%22Account%22%3A%20%22%22%2C%20%22BatchSystem%22%3A%20%22Host%22%2C%20%22Method%22%3A%20%22submitJob%22%2C%20%22SharedDir%22%3A%20%22%24HOME%22%2C%20%22OutputDir%22%3A%20%22%24HOME/data%22%2C%20%22ErrorDir%22%3A%20%22/home/diracpilot/localsite/error%22%2C%20%22WorkDir%22%3A%20%22%24HOME/work%22%2C%20%22InfoDir%22%3A%20%22%24HOME/info%22%2C%20%22ExecutionContext%22%3A%20%22SSHCE%22%2C%20%22User%22%3A%20%22diracpilot%22%2C%20%22Queue%22%3A%20%22queue%22%7D || python2 $HOME/execute_batch %7B%22Executable%22%3A%20%22/home/diracpilot/localsite/submission/DIRAC_8ut__z8j_pilotwrapper.py%22%2C%20%22NJobs%22%3A%201%2C%20%22SubmitOptions%22%3A%20%22%22%2C%20%22JobStamps%22%3A%20%5B%226ECC3B1F%22%5D%2C%20%22WholeNode%22%3A%20false%2C%20%22NumberOfProcessors%22%3A%201%2C%20%22NumberOfNodes%22%3A%20%221%22%2C%20%22Preamble%22%3A%20%22%22%2C%20%22NumberOfGPUs%22%3A%20null%2C%20%22Account%22%3A%20%22%22%2C%20%22BatchSystem%22%3A%20%22Host%22%2C%20%22Method%22%3A%20%22submitJob%22%2C%20%22SharedDir%22%3A%20%22%24HOME%22%2C%20%22OutputDir%22%3A%20%22%24HOME/data%22%2C%20%22ErrorDir%22%3A%20%22/home/diracpilot/localsite/error%22%2C%20%22WorkDir%22%3A%20%22%24HOME/work%22%2C%20%22InfoDir%22%3A%20%22%24HOME/info%22%2C%20%22ExecutionContext%22%3A%20%22SSHCE%22%2C%20%22User%22%3A%20%22diracpilot%22%2C%20%22Queue%22%3A%20%22queue%22%7D'
2023-04-20 11:20:15 UTC WorkloadManagement/SiteDirector/SSH [139969674434368] DEBUG: SSH command: ssh -q  -l diracpilot dirac-tuto "echo __DIRAC__; bash --login -c 'python $HOME/execute_batch %7B%22Executable%22%3A%20%22/home/diracpilot/localsite/submission/DIRAC_8ut__z8j_pilotwrapper.py%22%2C%20%22NJobs%22%3A%201%2C%20%22SubmitOptions%22%3A%20%22%22%2C%20%22JobStamps%22%3A%20%5B%226ECC3B1F%22%5D%2C%20%22WholeNode%22%3A%20false%2C%20%22NumberOfProcessors%22%3A%201%2C%20%22NumberOfNodes%22%3A%20%221%22%2C%20%22Preamble%22%3A%20%22%22%2C%20%22NumberOfGPUs%22%3A%20null%2C%20%22Account%22%3A%20%22%22%2C%20%22BatchSystem%22%3A%20%22Host%22%2C%20%22Method%22%3A%20%22submitJob%22%2C%20%22SharedDir%22%3A%20%22%24HOME%22%2C%20%22OutputDir%22%3A%20%22%24HOME/data%22%2C%20%22ErrorDir%22%3A%20%22/home/diracpilot/localsite/error%22%2C%20%22WorkDir%22%3A%20%22%24HOME/work%22%2C%20%22InfoDir%22%3A%20%22%24HOME/info%22%2C%20%22ExecutionContext%22%3A%20%22SSHCE%22%2C%20%22User%22%3A%20%22diracpilot%22%2C%20%22Queue%22%3A%20%22queue%22%7D || python3 $HOME/execute_batch %7B%22Executable%22%3A%20%22/home/diracpilot/localsite/submission/DIRAC_8ut__z8j_pilotwrapper.py%22%2C%20%22NJobs%22%3A%201%2C%20%22SubmitOptions%22%3A%20%22%22%2C%20%22JobStamps%22%3A%20%5B%226ECC3B1F%22%5D%2C%20%22WholeNode%22%3A%20false%2C%20%22NumberOfProcessors%22%3A%201%2C%20%22NumberOfNodes%22%3A%20%221%22%2C%20%22Preamble%22%3A%20%22%22%2C%20%22NumberOfGPUs%22%3A%20null%2C%20%22Account%22%3A%20%22%22%2C%20%22BatchSystem%22%3A%20%22Host%22%2C%20%22Method%22%3A%20%22submitJob%22%2C%20%22SharedDir%22%3A%20%22%24HOME%22%2C%20%22OutputDir%22%3A%20%22%24HOME/data%22%2C%20%22ErrorDir%22%3A%20%22/home/diracpilot/localsite/error%22%2C%20%22WorkDir%22%3A%20%22%24HOME/work%22%2C%20%22InfoDir%22%3A%20%22%24HOME/info%22%2C%20%22ExecutionContext%22%3A%20%22SSHCE%22%2C%20%22User%22%3A%20%22diracpilot%22%2C%20%22Queue%22%3A%20%22queue%22%7D || python2 $HOME/execute_batch %7B%22Executable%22%3A%20%22/home/diracpilot/localsite/submission/DIRAC_8ut__z8j_pilotwrapper.py%22%2C%20%22NJobs%22%3A%201%2C%20%22SubmitOptions%22%3A%20%22%22%2C%20%22JobStamps%22%3A%20%5B%226ECC3B1F%22%5D%2C%20%22WholeNode%22%3A%20false%2C%20%22NumberOfProcessors%22%3A%201%2C%20%22NumberOfNodes%22%3A%20%221%22%2C%20%22Preamble%22%3A%20%22%22%2C%20%22NumberOfGPUs%22%3A%20null%2C%20%22Account%22%3A%20%22%22%2C%20%22BatchSystem%22%3A%20%22Host%22%2C%20%22Method%22%3A%20%22submitJob%22%2C%20%22SharedDir%22%3A%20%22%24HOME%22%2C%20%22OutputDir%22%3A%20%22%24HOME/data%22%2C%20%22ErrorDir%22%3A%20%22/home/diracpilot/localsite/error%22%2C%20%22WorkDir%22%3A%20%22%24HOME/work%22%2C%20%22InfoDir%22%3A%20%22%24HOME/info%22%2C%20%22ExecutionContext%22%3A%20%22SSHCE%22%2C%20%22User%22%3A%20%22diracpilot%22%2C%20%22Queue%22%3A%20%22queue%22%7D'"
2023-04-20 11:20:16 UTC WorkloadManagement/SiteDirector/SSH [139969674434368] DEBUG: SSH command result {'OK': True, 'Value': (0, "\r\n__DIRAC__\r\npython: can't open file '/home/diracpilot/execute_batch': [Errno 2] No such file or directory\r\nbash: python3: command not found\r\npython2: can't open file '/home/diracpilot/execute_batch': [Errno 2] No such file or directory\r\n", '')}
2023-04-20 11:20:16 UTC WorkloadManagement/SiteDirector/dirac-tuto [139969674434368] ERROR: Invalid output from remote command python: can't open file '/home/diracpilot/execute_batch': [Errno 2] No such file or directory
bash: python3: command not found
python2: can't open file '/home/diracpilot/execute_batch': [Errno 2] No such file or directory
Traceback (most recent call last):
  File "/opt/dirac/versions/v8.0.18-1681988721/Linux-x86_64/lib/python3.9/site-packages/DIRAC/Resources/Computing/SSHComputingElement.py", line 525, in __executeHostCommand
    index = output.index("============= Start output ===============")
ValueError: substring not found
2023-04-20 11:20:16 UTC WorkloadManagement/SiteDirector/WorkloadManagement/SiteDirector [139969674434368] ERROR: Failed submission to queue Queue dirac-tuto_queue:
Invalid output from remote command: python: can't open file '/home/diracpilot/execute_batch': [Errno 2] No such file or directory
bash: python3: command not found
python2: can't open file '/home/diracpilot/execute_batch': [Errno 2] No such file or directory
2023-04-20 11:20:16 UTC WorkloadManagement/SiteDirector/WorkloadManagement/SiteDirector [139969674434368] VERBOSE: Committing pilot submission to accounting
2023-04-20 11:20:16 UTC WorkloadManagement/SiteDirector/WorkloadManagement/SiteDirector [139969674434368] INFO: Failed pilot submission Queue: dirac-tuto_queue
2023-04-20 11:20:16 UTC WorkloadManagement/SiteDirector/WorkloadManagement/SiteDirector [139969674434368] INFO: Total number of pilots submitted in this cycle 0
```


## WebApp

1. `docker cp dirac-tuto:/home/diracuser/.globus/certificate.p12 .`
2. Add certificate.p12 to browser
3. Add dirac-tuto to /etc/hosts of machine running the browser
4. Goto https://dirac-tuto:8443/DIRAC/s:MyDIRAC-Production/g:dirac_user/
