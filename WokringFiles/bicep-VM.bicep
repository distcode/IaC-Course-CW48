targetScope = 'resourceGroup'

param AdminUser string
@secure()
param AdminPwd string


module vNetHub 'xModuleVNet.bicep' = {
  name: 'iac-vNetHub'
  params: {
    Prefix: 'iac'
  }
}

resource vm 'Microsoft.Compute/virtualMachines@2026-04-01' = {
  name: 'iac-VM-1'
  location: 'France Central'
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D2alds_v7'
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2025-datacenter-core-smalldisk-g2'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        name: 'iac-DiskOS-VM-1'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
        }
      }
      dataDisks: [
        {
          createOption: 'Empty'
          lun: 1
          deleteOption: 'Delete'
          diskSizeGB: 32
          name: 'iac-DiskData-1-VM-1'
          managedDisk: {
            storageAccountType: 'Standard_LRS'
          }
        }
      ]
    }
    osProfile: {
      adminUsername: AdminUser
      adminPassword: AdminPwd
      computerName: 'SRV1'
      windowsConfiguration: {
        enableAutomaticUpdates: false
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
          properties: {
            deleteOption: 'Delete'
          }
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

resource nic 'Microsoft.Network/networkInterfaces@2026-03-01' = {
  name: 'iac-NIC-VM-1'
  location: 'France Central'
  properties: {
    ipConfigurations: [
      {
        name: 'FirstConfig'
        properties: {
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', vNetHub.outputs.Name, 'CentralResources')
          }
          publicIPAddress: {
            id: pubip.id
          }
        }
      }
    ]
  }
}

resource pubip 'Microsoft.Network/publicIPAddresses@2026-03-01' = {
  name: 'iac-PubIP-VM-1'
  location: 'France Central'
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}
