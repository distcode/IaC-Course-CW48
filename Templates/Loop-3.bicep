
// Loop example for creating multiple automation accounts based on an array of configurations.

targetScope = 'resourceGroup'

var Configurations = [
  {
    sku: 'Free'
    location: 'AustriaEast'
  }
  {
    sku: 'Basic'
    location: 'NorthEurope'
  }
]

resource iac_AutoAccount 'Microsoft.Automation/automationAccounts@2024-10-23' = [
  for (accountconfig,i) in Configurations: {
  name: 'iac-AutoAccount-${(i+1)}'
  location: accountconfig.location
  properties: {
    sku: {
      name: accountconfig.sku
    }
  }
}]
