@description('Azure region for the VM resources')
param location string

@description('Name of the virtual machine')
param vmName string

@description('Size of the virtual machine')
param vmSize string

@description('Administrator username')
param adminUsername string

@secure()
@description('Administrator password')
param adminPassword string

@description('Resource ID of the subnet to attach the NIC to')
param subnetId string

@description('Windows Server image offer')
param imageOffer string = 'WindowsServer'

@description('Windows Server image SKU')
param imageSku string = '2022-datacenter-g2'

var nicName = 'nic-${vmName}'
var osDiskName = 'osdisk-${vmName}'

resource nic 'Microsoft.Network/networkInterfaces@2024-01-01' = {
  name: nicName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: subnetId
          }
        }
      }
    ]
  }
}

resource vm 'Microsoft.Compute/virtualMachines@2024-07-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: imageOffer
        sku: imageSku
        version: 'latest'
      }
      osDisk: {
        name: osDiskName
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
  }
}

@description('Resource ID of the virtual machine')
output vmId string = vm.id

@description('Private IP address of the virtual machine')
output privateIpAddress string = nic.properties.ipConfigurations[0].properties.privateIPAddress
