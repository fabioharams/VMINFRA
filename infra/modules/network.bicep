@description('Azure region for the network resources')
param location string

@description('Number of subnets to create (one per VM)')
param subnetCount int = 3

var vnetName = 'vnet-vminfra'
var nsgName = 'nsg-default'

resource nsg 'Microsoft.Network/networkSecurityGroups@2024-01-01' = {
  name: nsgName
  location: location
  properties: {
    securityRules: [
      {
        name: 'DenyAllInbound'
        properties: {
          priority: 4096
          direction: 'Inbound'
          access: 'Deny'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

resource vnet 'Microsoft.Network/virtualNetworks@2024-01-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
  }
}

@batchSize(1)
resource subnets 'Microsoft.Network/virtualNetworks/subnets@2024-01-01' = [for i in range(1, subnetCount): {
  parent: vnet
  name: 'snet-${i}'
  properties: {
    addressPrefix: '10.0.${i}.0/24'
    networkSecurityGroup: {
      id: nsg.id
    }
  }
}]

@description('Resource IDs of the subnets')
output subnetIds string[] = [for i in range(0, subnetCount): subnets[i].id]
