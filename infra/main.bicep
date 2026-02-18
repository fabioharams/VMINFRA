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
    subnetCount: vmCount
  }
}

module virtualMachines 'modules/vm.bicep' = [
  for i in range(0, vmCount): {
    scope: rg
    params: {
      location: location
      vmName: '${vmNamePrefix}-${i + 1}'
      vmSize: vmSize
      adminUsername: adminUsername
      adminPassword: adminPassword
      subnetId: network.outputs.subnetIds[i]
    }
  }
]

// Sweden Central resources
module networkSwedenCentral 'modules/network-swedencentral.bicep' = {
  scope: rg
  params: {
    location: 'swedencentral'
  }
}

module vmSwedenCentral 'modules/vm.bicep' = {
  scope: rg
  params: {
    location: 'swedencentral'
    vmName: 'vm-swedencentral'
    vmSize: vmSize
    adminUsername: adminUsername
    adminPassword: adminPassword
    subnetId: networkSwedenCentral.outputs.subnetId
    imageOffer: 'WindowsServer'
    imageSku: '2025-datacenter-g2'
  }
}

// Global VNet peering between Brazil South and Sweden Central
module vnetPeering 'modules/peering.bicep' = {
  scope: rg
  params: {
    vnet1Name: network.outputs.vnetName
    vnet2Name: networkSwedenCentral.outputs.vnetName
    vnet1Id: network.outputs.vnetId
    vnet2Id: networkSwedenCentral.outputs.vnetId
  }
}
