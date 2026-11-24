@maxLength(4)
param Prefix string = 'iac'

@maxLength(15)
param VMName string = 'VM'

param VMSize string = 'Standard_B2as_v2'

param AdminUserName string = 'localadmin'

@secure()
param AdminPassword string

param location string = 'West Europe'


var fullVMName = '${Prefix}-${VMName}'
var fullVNetName = '${Prefix}-VNet'
var fullNICName = '${Prefix}-NIC'
var fullPubIPName = '${Prefix}-PubIP'
var fullNSGName = '${Prefix}-NSG'
var fullOSDiskName = '${Prefix}-OSDisk-${VMName}'

resource VM 'Microsoft.Compute/virtualMachines@2025-11-01' = {
  name: fullVMName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: VMSize
    }
    osProfile: {
      computerName: VMName
      adminUsername: AdminUserName
      adminPassword: AdminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2025-Datacenter-g2'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        name: fullOSDiskName
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: NIC.id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: false
      }
    }
  }
}

resource NIC 'Microsoft.Network/networkInterfaces@2025-05-01' = {
  name: fullNICName
  location: location
  tags: {
    Author: 'DIST'
    Course: 'IaC'
  }
  properties: {
    ipConfigurations: [
      {
        name: 'ipConfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', fullVNetName, 'Subnet-1')
          }
          publicIPAddress: {
            id: PubIP.id
          }
        }
      }
    ]
  }
  dependsOn: [
    VNet
    PubIP
  ]
}

resource VNet 'Microsoft.Network/virtualNetworks@2025-05-01' = {
  name: fullVNetName
  location: location
  tags: {
    Author: 'DIST'
    Course: 'IaC'
  }
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.101.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'Subnet-1'
        properties: {
          addressPrefix: '10.101.0.0/24'
          networkSecurityGroup: {
            id: NSG.id
          }
        }
      }
      {
        name: 'Subnet-2'
        properties: {
          addressPrefix: '10.101.1.0/24'
          networkSecurityGroup: {
            id: NSG.id
          }
        }
      }
    ]
  }
}

resource PubIP 'Microsoft.Network/publicIPAddresses@2025-05-01' = {
  name: fullPubIPName
  location: location
  tags: {
    Author: 'DIST'
    Course: 'IaC'
  }
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
    publicIPAddressVersion: 'IPv4'
  }
}

resource NSG 'Microsoft.Network/networkSecurityGroups@2025-05-01' = {
  name: fullNSGName
  location: location
  properties: {
    securityRules: [
      {
        name: 'RDP-Allow'
        properties: {
          description: 'Allow RDP traffic'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 500
          direction: 'Inbound'
        }
      }
    ]
  }
}
