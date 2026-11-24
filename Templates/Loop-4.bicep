
// Loop example for creating multiple automation accounts based on an array of configurations with a conditional deployment flag.

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
var DeployAutomationAccounts bool = true

resource iac_AutoAccount 'Microsoft.Automation/automationAccounts@2024-10-23' = [
  for (accountconfig,i) in Configurations : if (DeployAutomationAccounts) {
  name: 'iac-AutoAccount-${(i+1)}'
  location: accountconfig.location
  properties: {
    sku: {
      name: accountconfig.sku
    }
  }
}]
