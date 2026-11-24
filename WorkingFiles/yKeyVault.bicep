targetScope = 'resourceGroup'

resource kv 'Microsoft.KeyVault/vaults@2026-05-15' = {
  
  name: 'iac-kv-017'
  location: 'France Central'
  properties: {
    tenantId: subscription().tenantId
    sku: {
      family: 'A'
      name: 'standard'
    }
    enableSoftDelete: false
    publicNetworkAccess: 'Enabled'
    enableRbacAuthorization: true
  }
}
