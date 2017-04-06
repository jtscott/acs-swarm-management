# Azure Container Service (ACS) & Azure File Service (AFS) Scripts
Scripts to mount AFS on all Docker Swarm agents instead of using a volume plugin.
## Assumptions
These scripts assume you deployed ACS with a private key that has a password. There are parts of the scripts that create separate keys for looping through swarm agents quickly.

# Overview
The scripts assume execution in the following order
- swarm_storage_manager.sh - creates the dependencies to mount AFS
- mount_persitent_storage.sh - copies credentials to swarm agents
- host_health.sh - simple script that checks all agents for connectivity via a healthcheck text file.

# Using
After mounting the share you should be able to deploy containers with volume mappings to /mnt/persistent

# Gaps and Limitations
1. Need to monitor ACS for elastic scaling if another agent is added.
2. Need to monitor swarm agents for continued connectivity to AFS.
3. Ideally the AFS credentials would be stored in Azure Key Vault (AKV) and pulled by swarm_storage_manager.sh during setup instead of from stdin

# Shout Out
Props to [theonemule](https://github.com/theonemule/azure-file-storage-on-acs) for awesome examples