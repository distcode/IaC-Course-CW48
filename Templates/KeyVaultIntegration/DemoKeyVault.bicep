targetScope = 'resourceGroup'

param keyVaultName string = 'iac-keyvault-012'

param location string = resourceGroup().location

resource keyVault 'Microsoft.KeyVault/vaults@2026-05-15' = {
  name: keyVaultName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    enableSoftDelete: false
    tenantId: subscription().tenantId
    enabledForTemplateDeployment: true
    enableRbacAuthorization: true
    publicNetworkAccess: 'Enabled'
  }
}
