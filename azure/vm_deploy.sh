#!/bin/bash
# Variables

# Resource Group
myResourceGroup=<Replace with your Resource Group>

# Network configuration
# vnet
myVnet=<Replace with your vnet name>

# subnet
mySubnet=<Replace with your subnet name>

# Public IP address
myPublicIP=<Replace with your PIP name>

# Network security group
myNetworkSecurityGroup=<Replace with your NSG name>

# Network interface
myNic=<Replace with your NIC name>

# VM configuration
# VM name
myVM=<Replace with your VM name>

# Recovery Services vault
myRecoveryServicesVault=<Replace with your Recovery Services vault name>

# OMS Id and OMS key.
omsid=<Replace with your OMS Id>
omskey=<Replace with your OMS key>

# Get the latest version of OmsAgentForLinux
#publisher=Microsoft.EnterpriseCloud.Monitoring
#extension=OmsAgentForLinux
#location=westeurope
#latest=$(az vm extension image list-versions   --publisher ${publisher} -l ${location} -n ${extension}   --query "[].name" -o tsv | sort | tail -n 1)
#az vm extension image list -l ${location} --publisher ${publisher} -n ${extension} --version ${latest}


# Create a resource group.
az group create --name $myResourceGroup --location westeurope

# Create a virtual network.
az network vnet create --resource-group $myResourceGroup --name $myVnet --subnet-name $mySubnet

# Create a public IP address.
az network public-ip create --resource-group $myResourceGroup --name $myPublicIP

# Create a network security group.
az network nsg create --resource-group $myResourceGroup --name $myNetworkSecurityGroup

# Create a virtual network card and associate with public IP address and NSG.
az network nic create \
  --resource-group $myResourceGroup \
  --name $myNic \
  --vnet-name $myVnet \
  --subnet $mySubnet \
  --network-security-group $myNetworkSecurityGroup \
  --public-ip-address $myPublicIP

# Create a new virtual machine, this creates SSH keys if not present.
az vm create --resource-group $myResourceGroup --name $myVM --nics $myNic --image CentOS --admin-username algrega --size Standard_B1ms

# Open port 22 to allow SSh traffic to host.
az vm open-port --port 22 --resource-group $myResourceGroup --name $myVM

# Create a Recovery Services vault
az backup vault create --resource-group $myResourceGroup \
    --name $myRecoveryServicesVault \
    --location westeurope

# Enable backup for Azure VM
az backup protection enable-for-vm \
    --resource-group $myResourceGroup \
    --vault-name $myRecoveryServicesVault \
    --vm $myVM \
    --policy-name DefaultPolicy
    
# Install and configure the OMS agent.
az vm extension set \
  --resource-group $myResourceGroup \
  --vm-name $myVM \
  --name OmsAgentForLinux \
  --publisher Microsoft.EnterpriseCloud.Monitoring \
  --protected-settings '{"workspaceKey": "'"$omskey"'"}' \
  --settings '{"workspaceId": "'"$omsid"'"}'
