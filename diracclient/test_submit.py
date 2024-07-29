import sys
import time

import DIRAC
from DIRAC.WorkloadManagementSystem.Client.JobMonitoringClient import JobMonitoringClient
from DIRAC.WorkloadManagementSystem.Client.WMSClient import WMSClient

def test_submit():
    DIRAC.initialize()
    wms_client = WMSClient()
    monitoring = JobMonitoringClient()
    jdl = '''\
    JobName = "Simple_Job";
    Executable = "/bin/ls";
    Arguments = "-ltr";
    StdOutput = "StdOut";
    StdError = "StdErr";
    OutputSandbox = {"StdOut","StdErr"};
    '''
    res = wms_client.submitJob(jdl)
    job_id = res['Value']
    print(f'Job submitted with id {job_id}')
    max_checks = 100
    sleep_time = 3
    for i in range(max_checks):
        print('Checking status')
        result = monitoring.getJobsStatus(job_id)
        print(result)
        if result['Value'][job_id]['Status'] == 'Done':
            break
        time.sleep(sleep_time)
    else:
        raise Exception("Failed to finish job")