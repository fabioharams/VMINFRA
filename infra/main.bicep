targetScope = 'subscription'

@description('The Azure region for all resources')
param location string = 'brazilsouth'

@description('Name of the resource group')
param resourceGroupName string = 'rg-vminfra'

@description('Administrator username for the VMs')
param adminUsername string

@secure()
@description('Administrator password for the VMs')
param adminPassword string

@description('Number of virtual machines to deploy')
param vmCount int = 3

@description('VM size')
param vmSize string = 'Standard_D2as_v7'

@description('Base name prefix for VMs')
param vmNamePrefix string = 'vm'

resource rg 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: resourceGroupName
  location: location
}

module network 'modules/network.bicep' = {
  scope: rg
  params: {
    location: location
  }
}

module virtualMachines 'modules/vm.bicep' = [
  for i in range(1, vmCount): {
    scope: rg
    params: {
      location: location
      vmName: '${vmNamePrefix}-${i}'
      vmSize: vmSize
      adminUsername: adminUsername
      adminPassword: adminPassword
      subnetId: network.outputs.subnetId
    }
  }
]
