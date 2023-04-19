#!/usr/bin/env bash

# TODO make prettier by moving to install.cfg or using less commands

# set -euo pipefail

. bashrc
dirac-proxy-init -g dirac_admin -C /opt/dirac/user/client.pem -K /opt/dirac/user/client.key

# https://dirac.readthedocs.io/en/latest/AdministratorGuide/Tutorials/managingIdentities.html

cat | dirac-admin-sysadmin-cli --host dirac-tuto <<EOL
install db ProxyDB
install service Framework ProxyManager
quit
EOL

dirac-admin-add-group -G dirac_data -P NormalUser -P GenericPilot Users=ciuser AutoUploadProxy=True 
dirac-admin-add-shifter DataManager ciuser dirac_data

# https://dirac.readthedocs.io/en/latest/AdministratorGuide/Tutorials/diracSE.html
echo 'add instance DataManagement Production' | dirac-admin-sysadmin-cli --host dirac-tuto 
echo 'restart *' | dirac-admin-sysadmin-cli --host dirac-tuto
mkdir /opt/dirac/storageElementOne/ /opt/dirac/storageElementTwo/
dirac-install-component DataManagement StorageElement -m StorageElement -p BasePath="/opt/dirac/storageElementOne" -p Port=9148
dirac-install-component DataManagement StorageElementTwo -m StorageElement -p BasePath="/opt/dirac/storageElementTwo" -p Port=9147


# Use python to add:
# Resources {
#     StorageElements {
#         StorageElementOne
#         {
#         BackendType = DISET
#         DIP
#         {
#             Host = dirac-tuto
#             Port = 9148
#             Protocol = dips
#             Path = /DataManagement/StorageElement
#             Access = remote
#         }
#         }
#         StorageElementTwo
#         {
#         BackendType = DISET
#         DIP
#         {
#             Host = dirac-tuto
#             Port = 9147
#             Protocol = dips
#             Path = /DataManagement/StorageElementTwo
#             Access = remote
#         }
#         }
#     }
# }
python3 << EOL
import sys
import DIRAC

DIRAC.initialize() 

from DIRAC.ConfigurationSystem.Client.CSAPI import CSAPI

csAPI = CSAPI()

res = csAPI.createSection("Resources/StorageElements")
if not res["OK"]:
    print(res["Message"])
    sys.exit(1)

res = csAPI.createSection("Resources/StorageElements/StorageElementOne")
if not res["OK"]:
    print(res["Message"])
    sys.exit(1)

csAPI.setOption("Resources/StorageElements/StorageElementOne/BackendType", "DISET")

res = csAPI.createSection("Resources/StorageElements/StorageElementOne/DIP")
if not res["OK"]:
    print(res["Message"])
    sys.exit(1)

csAPI.setOption("Resources/StorageElements/StorageElementOne/DIP/Host", "dirac-tuto")
csAPI.setOption("Resources/StorageElements/StorageElementOne/DIP/Port", "9148")
csAPI.setOption("Resources/StorageElements/StorageElementOne/DIP/Protocol", "dips")
csAPI.setOption("Resources/StorageElements/StorageElementOne/DIP/Path", "/DataManagement/StorageElement")
csAPI.setOption("Resources/StorageElements/StorageElementOne/DIP/Access", "remote")

res = csAPI.createSection("Resources/StorageElements/StorageElementTwo")
if not res["OK"]:
    print(res["Message"])
    sys.exit(1)

csAPI.setOption("Resources/StorageElements/StorageElementTwo/BackendType", "DISET")

res = csAPI.createSection("Resources/StorageElements/StorageElementTwo/DIP")
if not res["OK"]:
    print(res["Message"])
    sys.exit(1)

csAPI.setOption("Resources/StorageElements/StorageElementTwo/DIP/Host", "dirac-tuto")
csAPI.setOption("Resources/StorageElements/StorageElementTwo/DIP/Port", "9147")
csAPI.setOption("Resources/StorageElements/StorageElementTwo/DIP/Protocol", "dips")
csAPI.setOption("Resources/StorageElements/StorageElementTwo/DIP/Path", "/DataManagement/StorageElementTwo")
csAPI.setOption("Resources/StorageElements/StorageElementTwo/DIP/Access", "remote")

res = csAPI.commit()
print(res)
EOL

dirac-restart-component DataManagement
dirac-restart-component Framework '*'  # ?needed

# https://dirac.readthedocs.io/en/latest/AdministratorGuide/Tutorials/installDFC.html

cat | dirac-admin-sysadmin-cli --host dirac-tuto <<EOL
install db FileCatalogDB
install service DataManagement FileCatalog
quit
EOL

# Use python to add:
# Resources {
#     FileCatalogs {
#         FileCatalog {}
#     }
# }
# Operations/Defaults/Services/Catalogs {
#     FileCatalog
#     {
#     AccessType = Read-Write
#     Status = Active
#     Master = True
#     }
# } 
python3 << EOL
import sys
import DIRAC

DIRAC.initialize() 

from DIRAC.ConfigurationSystem.Client.CSAPI import CSAPI

csAPI = CSAPI()

res = csAPI.createSection("Resources/FileCatalogs/")
if not res["OK"]:
    print(res["Message"])
    sys.exit(1)

res = csAPI.createSection("Resources/FileCatalogs/FileCatalog")
if not res["OK"]:
    print(res["Message"])
    sys.exit(1)

res = csAPI.createSection("Operations/Defaults/Services/Catalogs/FileCatalog")
if not res["OK"]:
    print(res["Message"])
    sys.exit(1)

csAPI.setOption("Operations/Defaults/Services/Catalogs/FileCatalog/AccessType", "Read-Write")
csAPI.setOption("Operations/Defaults/Services/Catalogs/FileCatalog/Status", "Active")
csAPI.setOption("Operations/Defaults/Services/Catalogs/FileCatalog/Master", "True")

res = csAPI.commit()
print(res)
EOL

# https://dirac.readthedocs.io/en/latest/AdministratorGuide/Tutorials/installRMS.html

cat | dirac-admin-sysadmin-cli --host dirac-tuto <<EOL
# Part of install.cfg?
# add instance RequestManagement Production
# restart *
install db ReqDB
install service RequestManagement ReqManager
install agent RequestManagement RequestExecutingAgent
quit
EOL


# https://dirac.readthedocs.io/en/latest/AdministratorGuide/Tutorials/installTS.html#tuto-install-ts


cat | dirac-admin-sysadmin-cli --host dirac-tuto <<EOL
# Part of install.cfg?
# add instance Transformation Production
# restart *
install db TransformationDB
install service Transformation TransformationManager
install agent Transformation TransformationAgent -p PollingTime=30
install agent Transformation InputDataAgent -p PollingTime=30
install agent Transformation WorkflowTaskAgent -p PollingTime=30 -p MonitorTasks=True -p MonitorFiles=True
install agent Transformation RequestTaskAgent -p PollingTime=30 -p MonitorTasks=True -p MonitorFiles=True
quit
EOL

dirac-admin-add-group -G dirac_prod -P ProductionManagement -P NormalUser Users=ciuser AutoUploadProxy=True
dirac-restart-component ProxyManager
dirac-admin-add-shifter ProdManager ciuser dirac_prod


# Use python to add:
# Resources {
# Sites
# {
#   MyGrid
#   {
#     MyGrid.Site1.uk
#     {
#       SE = StorageElementOne
#     }
#     MyGrid.Site2.de
#     {
#       SE = StorageElementTwo
#     }
#   }
# }
# } 
python3 << EOL
import sys
import DIRAC

DIRAC.initialize() 

from DIRAC.ConfigurationSystem.Client.CSAPI import CSAPI

csAPI = CSAPI()

res = csAPI.createSection("Resources/Sites/")
if not res["OK"]:
    print(res["Message"])
    sys.exit(1)

res = csAPI.createSection("Resources/Sites/MyGrid")
if not res["OK"]:
    print(res["Message"])
    sys.exit(1)

res = csAPI.createSection("Resources/Sites/MyGrid/MyGrid.Site1.uk")
if not res["OK"]:
    print(res["Message"])
    sys.exit(1)

csAPI.setOption("Resources/Sites/MyGrid/MyGrid.Site1.uk/SE", "StorageElementOne")

res = csAPI.createSection("Resources/Sites/MyGrid/MyGrid.Site1.de")
if not res["OK"]:
    print(res["Message"])
    sys.exit(1)

csAPI.setOption("Resources/Sites/MyGrid/MyGrid.Site1.de/SE", "StorageElementTwo")

res = csAPI.commit()
print(res)
EOL

# https://dirac.readthedocs.io/en/latest/AdministratorGuide/Tutorials/installWMS.html

cat | dirac-admin-sysadmin-cli --host dirac-tuto <<EOL
# Part of install.cfg?
# add instance WorkloadManagement Production
# restart *
install db JobDB
install db JobLoggingDB
install db PilotAgentsDB
install db SandboxMetadataDB
install db TaskQueueDB
install service WorkloadManagement PilotManager
install service WorkloadManagement JobManager
install service WorkloadManagement JobMonitoring
install service WorkloadManagement JobStateUpdate
install service WorkloadManagement Matcher
install service WorkloadManagement OptimizationMind
install service WorkloadManagement SandboxStore
install service WorkloadManagement WMSAdministrator
install service Framework BundleDelivery
install service Framework ComponentMonitoring
install agent WorkloadManagement SiteDirector
install agent WorkloadManagement JobCleaningAgent
install agent WorkloadManagement PilotStatusAgent
install agent WorkloadManagement StalledJobAgent
install executor WorkloadManagement Optimizers
restart WorkloadManagement *
quit
EOL

# `install service Framework Monitoring` fails with:
# Loading configuration template from DIRAC.FrameworkSystem
# Can not find Services/Monitoring in template
# [ERROR] Can not find Services/Monitoring in template
# Replaced with `install service Framework ComponentMonitoring`

mkdir -p /opt/dirac/webRoot/www/pilot
# Use python to add:
# Resources
# {
#   Sites
#   {
#     MyGrid
#     {
#       MyGrid.Site1.uk
#       {
#         CE = dirac-tuto
#         CEs
#         {
#           dirac-tuto
#           {
#             CEType = SSH
#             SSHHost = dirac-tuto
#             SSHUser = diracpilot
#             SSHPassword = password
#             SSHType = ssh
#             Queues
#             {
#               queue
#               {
#                 CPUTime = 40000
#                 MaxTotalJobs = 5
#                 MaxWaitingJobs = 10
#                 BundleProxy = True
#                 BatchError = /home/diracpilot/localsite/error
#                 ExecutableArea = /home/diracpilot/localsite/submission
#                 RemoveOutput = True
#               }
#             }
#           }
#         }
#       }
#     }
#   }
# }
# Operations/MyDIRAC-Production {
#     Pilot
#     {
#     Version = v7r0p36
#     CheckVersion = False
#     Command
#     {
#         Test = GetPilotVersion
#         Test += CheckWorkerNode
#         Test += InstallDIRAC
#         Test += ConfigureBasics
#         Test += ConfigureCPURequirements
#         Test += ConfigureArchitecture
#         Test += CheckCECapabilities
#         Test += LaunchAgent
#     }
#     GenericPilotGroup = dirac_user
#     GenericPilotUser = ciuser
#     pilotFileServer = dirac-tuto:8443
#     }
# }
# WebApp {
#     StaticDirs = pilot
# }
python3 << EOL
import sys
import DIRAC

DIRAC.initialize() 

from DIRAC.ConfigurationSystem.Client.CSAPI import CSAPI

csAPI = CSAPI()

csAPI.setOption("Resources/Sites/MyGrid/MyGrid.Site1.uk/CE", "dirac-tuto")

res = csAPI.createSection("Resources/Sites/MyGrid/MyGrid.Site1.uk/CEs")
if not res["OK"]:
    print(res["Message"])
    sys.exit(1)

res = csAPI.createSection("Resources/Sites/MyGrid/MyGrid.Site1.uk/CEs/dirac-tuto")
if not res["OK"]:
    print(res["Message"])
    sys.exit(1)

csAPI.setOption("Resources/Sites/MyGrid/MyGrid.Site1.uk/CEs/dirac-tuto/CEType", "SSH")
csAPI.setOption("Resources/Sites/MyGrid/MyGrid.Site1.uk/CEs/dirac-tuto/SSHHost", "dirac-tuto")
csAPI.setOption("Resources/Sites/MyGrid/MyGrid.Site1.uk/CEs/dirac-tuto/SSHUser", "diracpilot")
csAPI.setOption("Resources/Sites/MyGrid/MyGrid.Site1.uk/CEs/dirac-tuto/SSHPassword", "password")
csAPI.setOption("Resources/Sites/MyGrid/MyGrid.Site1.uk/CEs/dirac-tuto/SSHType", "ssh")

res = csAPI.createSection("Resources/Sites/MyGrid/MyGrid.Site1.uk/CEs/dirac-tuto/Queues")
if not res["OK"]:
    print(res["Message"])
    sys.exit(1)

res = csAPI.createSection("Resources/Sites/MyGrid/MyGrid.Site1.uk/CEs/dirac-tuto/Queues/queue")
if not res["OK"]:
    print(res["Message"])
    sys.exit(1)

csAPI.setOption("Resources/Sites/MyGrid/MyGrid.Site1.uk/CEs/dirac-tuto/Queues/queue/CPUTime", "40000")
csAPI.setOption("Resources/Sites/MyGrid/MyGrid.Site1.uk/CEs/dirac-tuto/Queues/queue/MaxTotalJobs", "5")
csAPI.setOption("Resources/Sites/MyGrid/MyGrid.Site1.uk/CEs/dirac-tuto/Queues/queue/MaxWaitingJobs", "10")
csAPI.setOption("Resources/Sites/MyGrid/MyGrid.Site1.uk/CEs/dirac-tuto/Queues/queue/BundleProxy", "True")
csAPI.setOption("Resources/Sites/MyGrid/MyGrid.Site1.uk/CEs/dirac-tuto/Queues/queue/BatchError", "/home/diracpilot/localsite/error")
csAPI.setOption("Resources/Sites/MyGrid/MyGrid.Site1.uk/CEs/dirac-tuto/Queues/queue/ExecutableArea", "/home/diracpilot/localsite/submission")

csAPI.setOption("Resources/Sites/MyGrid/MyGrid.Site1.uk/CEs/dirac-tuto/Queues/queue/RemoveOutput", "True")

res = csAPI.createSection("Operations/MyDIRAC-Production")
if not res["OK"]:
    print(res["Message"])
    sys.exit(1)

res = csAPI.createSection("Operations/MyDIRAC-Production/Pilot")
if not res["OK"]:
    print(res["Message"])
    sys.exit(1)

csAPI.setOption("Operations/MyDIRAC-Production/Pilot/Version", "v7r0p36")
csAPI.setOption("Operations/MyDIRAC-Production/Pilot/CheckVersion", "False")

res = csAPI.createSection("Operations/MyDIRAC-Production/Pilot/Command")
if not res["OK"]:
    print(res["Message"])
    sys.exit(1)

csAPI.setOption("Operations/MyDIRAC-Production/Pilot/Command/Test", "GetPilotVersion,CheckWorkerNode,InstallDIRAC,ConfigureBasics,ConfigureCPURequirements,ConfigureArchitecture,CheckCECapabilities,LaunchAgent")

csAPI.setOption("Operations/MyDIRAC-Production/Pilot/GenericPilotGroup", "dirac_user")
csAPI.setOption("Operations/MyDIRAC-Production/Pilot/GenericPilotUser", "ciuser")
csAPI.setOption("Operations/MyDIRAC-Production/Pilot/pilotFileServer", "dirac-tuto:8443")

csAPI.setOption("WebApp/StaticDirs", "pilot")

res = csAPI.commit()
print(res)
EOL

echo 'install service DataManagement ProductionSandboxSE -m StorageElement -p Port=9146 -p BasePath=/opt/dirac/storage/sandboxes' | dirac-admin-sysadmin-cli --host dirac-tuto

# Use python to add:
# /Resources/StorageElements {
#     ProductionSandboxSE
#     {
#         BackendType = DISET
#         DIP
#         {
#             Host = dirac-tuto
#             Port = 9146
#             Protocol = dips
#             Path = /DataManagement/ProductionSandboxSE
#             Access = remote
#         }
#     }
# }
python3 << EOL
import sys
import DIRAC

DIRAC.initialize() 

from DIRAC.ConfigurationSystem.Client.CSAPI import CSAPI

csAPI = CSAPI()

res = csAPI.createSection("Resources/StorageElements/ProductionSandboxSE")
if not res["OK"]:
    print(res["Message"])
    sys.exit(1)

csAPI.setOption("Resources/StorageElements/ProductionSandboxSE/BackendType", "DISET")

res = csAPI.createSection("Resources/StorageElements/ProductionSandboxSE/DIP")
if not res["OK"]:
    print(res["Message"])
    sys.exit(1)

csAPI.setOption("Resources/StorageElements/ProductionSandboxSE/DIP/Host", "dirac-tuto")
csAPI.setOption("Resources/StorageElements/ProductionSandboxSE/DIP/Port", "9146")
csAPI.setOption("Resources/StorageElements/ProductionSandboxSE/DIP/Protocol", "dips")
csAPI.setOption("Resources/StorageElements/ProductionSandboxSE/DIP/Path", "/DataManagement/ProductionSandboxSE")
csAPI.setOption("Resources/StorageElements/ProductionSandboxSE/DIP/Access", "remote")

res = csAPI.commit()
print(res)
EOL

dirac-admin-allow-site MyGrid.Site1.uk "test" -E False

echo 'restart WorkloadManagement *' | dirac-admin-sysadmin-cli --host dirac-tuto

# Make sure pilot has proxy it can use
dirac-proxy-init -g dirac_data -C /opt/dirac/user/client.pem -K /opt/dirac/user/client.key

# TODO make intervals shorter to make using in test suite quicker

# TODO add CE which can run singularity

# TODO add monitoring?
# see https://github.com/DIRACGrid/DIRAC/blob/integration/docs/source/AdministratorGuide/Systems/MonitoringSystem/index.rst
# will need opensearch service to be set up

# TODO add cvmfs to store apptainer images

