@description('Name of the first VNet')
param vnet1Name string

@description('Name of the second VNet')
param vnet2Name string

@description('Resource ID of the second VNet (remote for vnet1)')
param vnet2Id string

@description('Resource ID of the first VNet (remote for vnet2)')
param vnet1Id string

resource vnet1 'Microsoft.Network/virtualNetworks@2024-01-01' existing = {
  name: vnet1Name
}

resource vnet2 'Microsoft.Network/virtualNetworks@2024-01-01' existing = {
  name: vnet2Name
}

resource peeringFromVnet1ToVnet2 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2024-01-01' = {
  parent: vnet1
  name: '${vnet1Name}-to-${vnet2Name}'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: vnet2Id
    }
  }
}

resource peeringFromVnet2ToVnet1 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2024-01-01' = {
  parent: vnet2
  name: '${vnet2Name}-to-${vnet1Name}'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: vnet1Id
    }
  }
}
