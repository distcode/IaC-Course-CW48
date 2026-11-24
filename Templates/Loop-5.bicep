
// Loop example for creating multiple automation accounts based on an array of configurations with a conditional filter for 'Free' SKU.

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
  for (accountconfig,i) in Configurations : if (accountconfig.sku == 'Free') {
  name: 'iac-AutoAccount-${(i+1)}'
  location: accountconfig.location
  properties: {
    sku: {
      name: accountconfig.sku
    }
  }
}]
