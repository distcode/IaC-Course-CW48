param Prefix string = 'iac'

var Config array = [
  {
    NICName: 'NIC-Srv1'
    Deploy: true
  }
  {
    NICName: 'NIC-DC1'
    Deploy: true
  }
  {
    NICName: 'NIC-Srv2'
    Deploy: false
  }
  {
    NICName: 'NIC-Srv3'
    Deploy: false
  }
  {
    NICName: 'NIC-DC2'
    Deploy: true
  }
]

resource vnetHub 'Microsoft.Network/virtualNetworks@2026-03-01' = {
  name: '${Prefix}-VNet-Hub'
  location: 'North Europe'
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

resource NIC 'Microsoft.Network/networkInterfaces@2026-03-01' = [
  for item in Config : if (item.Deploy == true) {
    name: '${Prefix}-${item.NICName}'

    location: 'North Europe'
    properties: {
      ipConfigurations: [
        {
          name: 'FirstConfig'
          properties: {
            subnet: {
              id: resourceId('Microsoft.Network/virtualNetworks/subnets', vnetHub.name, 'TestResources')
            }
          }
        }
      ]
    }
  }
]

/*
resource NIC 'Microsoft.Network/networkInterfaces@2026-03-01' = [ for i in range (0,4) : if (DeployNIC == true) {
  
  name: '${Prefix}-NIC-${(i + 1)}'
  
  location: 'North Europe'
  properties: {
    ipConfigurations: [
      {
        name: 'FirstConfig'
        properties: {
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets',vnetHub.name,'TestResources')
          }
        }
      }
    ]
  }
}]
*/

output SubnetID string = resourceId('Microsoft.Network/virtualNetworks/subnets', vnetHub.name, 'TestResources')
