#!/bin/bash

# Variables
# OMS Id and OMS key.
omsid=<Replace with your OMS Id>
omskey=<Replace with your OMS key>


# Create a resource group.
az group create --name TEST-RG --location westeurope

# Create a virtual network.
az network vnet create --resource-group TEST-RG --name myVnet --subnet-name mySubnet

# Create a public IP address.
az network public-ip create --resource-group TEST-RG --name myPublicIP

# Create a network security group.
az network nsg create --resource-group TEST-RG --name myNetworkSecurityGroup

# Create a virtual network card and associate with public IP address and NSG.
az network nic create \
  --resource-group TEST-RG \
  --name myNic \
  --vnet-name myVnet \
  --subnet mySubnet \
  --network-security-group myNetworkSecurityGroup \
  --public-ip-address myPublicIP

# Create a new virtual machine, this creates SSH keys if not present.
az vm create --resource-group TEST-RG --name myVM --nics myNic --image CentOS --admin-username algrega --size Standard_B1ms

# Open port 22 to allow SSh traffic to host.
az vm open-port --port 22 --resource-group TEST-RG --name myVM

# Create a Recovery Services vault
az backup vault create --resource-group TEST-RG \
    --name myRecoveryServicesVault \
    --location westeurope

# Enable backup for Azure VM
az backup protection enable-for-vm \
    --resource-group TEST-RG \
    --vault-name myRecoveryServicesVault \
    --vm myVM \
    --policy-name DefaultPolicy
    
# Install and configure the OMS agent.
az vm extension set \
  --resource-group myResourceGroup \
  --vm-name myVM \
  --name OmsAgentForLinux \
  --publisher Microsoft.EnterpriseCloud.Monitoring \
  --version 1.0 --protected-settings '{"workspaceKey": "'"$omskey"'"}' \
  --settings '{"workspaceId": "'"$omsid"'"}'
