param Prefix string = 'iac'
param Location string = 'France Central'

resource vnetHub 'Microsoft.Network/virtualNetworks@2026-03-01' = {
  name: '${Prefix}-VNet-Hub'
  location: Location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.200.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'CentralResources'
        properties: {
          addressPrefix: '10.200.0.0/24'
        }
      }
      {
        name: 'IdentityServer'
        properties: {
          addressPrefix: '10.200.1.0/24'
        }
      }
      {
        name: 'TestResources'
        properties: {
          addressPrefix: '10.200.2.0/24'
        }
      }
    ]
  }
}

output Name string = vnetHub.name
