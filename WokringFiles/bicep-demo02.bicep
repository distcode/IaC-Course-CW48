
targetScope = 'resourceGroup'

param Prefix string = 'iac'

resource sa1 'Microsoft.Storage/storageAccounts@2026-09-01' = {
  name: '${Prefix}sa0123'
  location: 'North Europe'
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  tags: {
    Author: 'DIST'
    'hidden-title': 'DIST IaC Demo'
  }
  properties: {
    accessTier: 'Cold'
    supportsHttpsTrafficOnly: true
  }
}

output saName string = sa1.name

