
@allowed(['Yes','No'])
param DeploySA string

resource sa2 'Microsoft.Storage/storageAccounts@2026-09-01' = if ( DeploySA == 'Yes') {
  name: 'iacsa01235'
  location: 'North Europe'
  sku: {name: 'Standard_LRS'}
  kind: 'StorageV2'
}

output SADeployed string = (DeploySA == 'Yes') ? 'SA was deployed' : 'No SA deployed'
